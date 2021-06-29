{ config, lib, pkgs, ... }:

let
  inherit (lib) types;

  cfg = config.virtualisation;

  system = config.nixpkgs.localSystem.system;
  # TODO: this doesn't work with ${config.nixpkgs.pkgs}; why?
  evalConfig = import <nixpkgs/nixos/lib/eval-config.nix>;

  # currently we're using the CLI interface, but the settings intentionally
  # follow the JSON schema described by the c-h API docs
  settingsFormat = pkgs.formats.json {};

  mkVMConfigType = { name, config, ... }: lib.mkOptionType {
    name = "Toplevel NixOS config";
    merge = loc: defs: (evalConfig {
      inherit system;
      modules =
        let
          # TODO: is the interface name guaranteed to be stable?
          iface = "ens1";
          extraConfig = {
            _file = "module at ${__curPos.file}:${toString __curPos.line}";
            config = {
              networking.hostName = lib.mkDefault name;
              networking.useDHCP = false;
              # TODO: per-VM networking settings:
              networking.interfaces.${iface}.ipv4.addresses = [
                { address = config.guestAddress; prefixLength = 32; }
              ];
              networking.defaultGateway.address = config.hostAddress;
              networking.defaultGateway.interface = iface;
            };
          };
        in [ ./vm-base-config.nix extraConfig ] ++ (map (x: x.value) defs);
      prefix = [ "virtualisation" "machines" name ];
    }).config;
  };

  machineOpts = { name, config, ... }: {
    options.config = lib.mkOption {
      description = ''
        A specification of the desired configuration of this virtual machine,
        as a NixOS module.
      '';
      type = mkVMConfigType { inherit name config; };
    };

    options.autoStart = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the VM is automatically started at boot-time.";
    };

    options.hostAddress = lib.mkOption {
      type = types.str;
      example = "10.4.2.1";
      description = ''
        IPv4 address assigned on the host side to the tap interface created
        for the VM.  Uses peer addresses such that multiple VMs can share the
        same host-side address.
      '';
    };

    options.guestAddress = lib.mkOption {
      type = types.str;
      example = "10.4.2.2";
      description = ''
        IPv4 address assigned on the guest side to the virtualised network
        interface inside the VM.
      '';
    };

    # TODO: additional fs & networking options etc
  };

  toCliOptions = cfg:
    let
      convertValue = v:
        if lib.isString v
          then v
        else if lib.isInt v
          then toString v
        else if lib.isBool v
          then (if v then "on" else "off")
        else if lib.isAttrs v
          then lib.concatStringsSep "," (lib.mapAttrsToList (k: w: "${k}=${convertValue w}") v)
        else
          throw "don't know how to serialize '${builtins.typeOf v}' to cloud-hypervisor CLI options";

      convertAndEscape = v: lib.escapeShellArg (convertValue v);

      toOption_ = k: v: [ "--${k}" ] ++ map convertAndEscape (lib.toList v);
      toOption = k: v: # special case for the 'path' options
        if k == "kernel" || k == "initramfs"
        then toOption_ k (v.path)
        else toOption_ k v;

      toArgs = cfg: lib.concatLists (lib.mapAttrsToList toOption cfg);

    in lib.concatStringsSep " " (toArgs cfg);

in {

  options.virtualisation.machines = lib.mkOption {
    type = types.attrsOf (types.submodule machineOpts);
    default = {};
    description = ''
      Attribute set of configuration for NixOS virtual machines to be run
      under cloud-hypervisor.  The NixOS configuration is held under the
      'config' attribute in each machine specification.
    '';
  };

  config = lib.mkIf (cfg.machines != {}) (
    let
      optionsList = lib.imap0 (index: { name, value }:
        let
          opts = value;
          inherit (opts.config.system.build) toplevel kernel;
          virtiofsNixStore = "${name}-nixstore";
          tapName = "vm-tap${toString index}";
        in {
          virtiofsDevices.${virtiofsNixStore} = {
            # TODO: restrict to system closure of /nix/store
            source = "/nix/store";
            group = "cloud-hypervisor";
            # make sure that we restart this device if we restart the VM, since the VM
            # needs the device to boot
            unit.partOf = [ "cloud-hypervisor@testy.service" ];
          };

          systemdServices."cloud-hypervisor@${name}" = {
            requires = [ "virtiofs@${virtiofsNixStore}.service" ];
            after = [ "virtiofs@${virtiofsNixStore}.service" ];
            path = [ pkgs.iproute2 ];
            preStart = ''
              ip tuntap add name ${tapName} mode tap
              ip addr add ${opts.hostAddress} peer ${opts.guestAddress}/32 dev ${tapName}
            '';
            postStop = ''
              ip tuntap del name ${tapName} mode tap
            '';
          };

          # TODO: clever switch-to-configuration when nixos vm config changes
          chMachines.${name} = {
            autoStart = opts.autoStart;
            settings = {
              kernel.path = "${kernel.dev}/vmlinux";
              initramfs.path = "${toplevel}/initrd";
              memory.shared = true;
              fs = [ {
                tag = "nix-store";
                socket = "/var/run/virtiofsd-socks/${virtiofsNixStore}.sock";
                num_queues = 1;
                queue_size = 1;
                dax = false;
              } ];
              rng = [];
              cmdline = lib.concatStringsSep " " [
                "console=ttyS0"
                "init=${toplevel}/init"
                "boot.panic_on_fail"
              ];
              console = "off";
              serial = "tty";
              net.tap = tapName;
            };
          };
        }) (lib.mapAttrsToList lib.nameValuePair cfg.machines);

      merge = x: y: x // y;
      mapAndMerge = f: arr: lib.foldl merge {} (map f arr);

    in {
      networking.networkmanager.unmanaged = [ "interface-name:vm-*" ];
      networking.dhcpcd.denyInterfaces = [ "vm-*" ];

      virtualisation.virtiofs.devices = mapAndMerge (x: x.virtiofsDevices) optionsList;
      virtualisation.cloud-hypervisor.machines = mapAndMerge (x: x.chMachines) optionsList;
      systemd.services = mapAndMerge (x: x.systemdServices) optionsList;
    }
  );

}
