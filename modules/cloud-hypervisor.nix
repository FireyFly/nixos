{ config, lib, pkgs, ... }:

let
  inherit (lib) types;

  cfg = config.virtualisation.cloud-hypervisor;

  # currently we're using the CLI interface, but the settings intentionally
  # follow the JSON schema described by the c-h API docs
  settingsFormat = pkgs.formats.json {};

  vmOpts = { ... }: {
    options.user = lib.mkOption {
      type = types.str;
      default = "cloud-hypervisor";
      description = "User account under which to run this VM.";
    };
    options.group = lib.mkOption {
      type = types.str;
      default = "cloud-hypervisor";
      description = "Group under which to run this VM.";
    };
    options.autoStart = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Whether the VM is automatically started at boot-time.";
    };
    options.settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
      description = ''
        cloud-hypervisor configuration for a single VM; see schema at
        <https://raw.githubusercontent.com/cloud-hypervisor/cloud-hypervisor/master/vmm/src/api/openapi/cloud-hypervisor.yaml#/components/schemas/VmConfig>
        and upstream documentation for details.
      '';
    };
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

  options.virtualisation.cloud-hypervisor = {
    machines = lib.mkOption {
      type = types.attrsOf (types.submodule vmOpts);
      default = {};
      description = "Attribute set of configuration for virtual machines to run with cloud-hypervisor.";
    };
  };

  config = lib.mkIf (cfg.machines != {}) {
    users.users.cloud-hypervisor = let
      hasSystemUser = lib.any (x: x == "cloud-hypervisor")
          (lib.mapAttrsToList (_: opts: opts.user) cfg.machines);
    in lib.mkIf hasSystemUser {
      uid = 991; # FIXME
      isSystemUser = true;
    };

    users.groups.cloud-hypervisor = let
      hasSystemGroup = lib.any (x: x == "cloud-hypervisor")
          (lib.mapAttrsToList (_: opts: opts.group) cfg.machines);
    in lib.mkIf hasSystemGroup {
      gid = 991; # FIXME
    };

    systemd.services = lib.listToAttrs (
      lib.mapAttrsToList (name: opts: lib.nameValuePair "cloud-hypervisor@${name}" ({
        description = "cloud-hypervisor machine '${name}'";
        serviceConfig = {
          Type = "simple";
          # TODO: notify after startup?, also disable getty
          # TODO: figure out how to handle failures more properly
          User = opts.user;
          Group = opts.group;
          # TODO: run with --api-socket & allow control of access to API socket
          ExecStart = "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor -v ${toCliOptions opts.settings}";

          AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];

          PrivateTmp = true;
          WorkingDirectory = "/tmp";
        };
      } // (if opts.autoStart then {
        wantedBy = [ "machines.target" ];
        wants = [ "network.target" ];
        after = [ "network.target" ];
        # TODO: restart if VM `opts.settings` changes
        # -- or better yet, avoid restart for some changes and just update VM
        #    through socket API
      } else {}))) cfg.machines);
  };

}
