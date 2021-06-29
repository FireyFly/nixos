{ config, lib, pkgs, ... }:

let
  inherit (lib) types;

  cfg = config.virtualisation.virtiofs;

  runtimeDir = "/var/run/virtiofsd-socks";

  virtiofsOpts = { ... }: {
    options.source = lib.mkOption {
      type = types.str;
      description = "Source directory to expose as a virtiofs device.";
    };
    options.group = lib.mkOption {
      type = types.nullOr types.str;
    # default = null;
      description = "Group to provide access to the device socket to.";
    };
    options.unit = lib.mkOption {
      # TODO: properly type/express this
      type = types.attrsOf (types.listOf types.str);
      default = {};
      description = "Additional systemd unit properties to express dependencies.";
    };
    options.socketPath = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      defaultText = "${runtimeDir}/\${name}.sock";
      description = "Path to Unix domain socket to offer the device over.";
    };
  };

in {

  # options:
  #   cache=                auto|always|none
  #   [no_]flock
  #   log_level=            debug|info|warn|err
  #   max_idle_threads=     <n>
  #   [no_]posix_lock
  #   [no_]readdirplus
  #   sandbox=              namespace|chroot
  #   timeout=              <n>
  #   [no_]writeback
  #   [no_]xattr
  #   modcaps=              (caplist)
  #   [no_]allow_direct_io
  #   [no_]?announce_submounts
  #  *source=               PATH
  #   [no_]?allow_root
  # other flags:
  #   --rlimit-nofile=      <n>
  #   --socket-path=
  #   --socket-group=
  #   --fd=                 <n>
  #   --thread-pool-size=   <n>

  options.virtualisation.virtiofs = {
    devices = lib.mkOption {
      type = types.attrsOf (types.submodule virtiofsOpts);
      default = {};
      description = "Attribute set of virtual devices to instantiate with virtiofsd.";
    };
  };

  config = lib.mkIf (cfg.devices != {}) {
    systemd.services = lib.listToAttrs (
      lib.mapAttrsToList (name: opts: lib.nameValuePair "virtiofs@${name}" (let
        socketPath =
          if opts.socketPath == null
          then "${runtimeDir}/${name}.sock"
          else opts.socketPath;
        args = [
          "--socket-path=${socketPath}"
          "--socket-group=${opts.group}"
          "-o" "source=${opts.source}"
          "-o" "cache=none"
        ];
        argsStr = lib.concatStringsSep " " (map lib.escapeShellArg args);
      in opts.unit // {
        description = "virtiofs device '${name}' for ${opts.source}";
        serviceConfig = {
          Type = "simple";
          # TODO: look into 'notify'/wait for socket creation
          User = "root";
          Group = opts.group;
          ExecStart = "${pkgs.qemu}/libexec/virtiofsd ${argsStr}";

          PrivateTmp = true;
          WorkingDirectory = "/tmp";
          RuntimeDirectory = "virtiofsd-socks";
          RuntimeDirectoryMode = "0755";
        };
      })) cfg.devices);
  };

}
