{ config, lib, pkgs, ... }:

let
  inherit (lib) types;
  cfg = config.services.biboumi;

in
{
  ###### interface

  options = {

    services.biboumi = {

      enable = lib.mkEnableOption "Biboumi XMPP-IRC gateway";

      package = lib.mkOption {
        type = types.package;
        description = "Biboumi package to use";
        default = pkgs.biboumi;
        defaultText = "pkgs.biboumi";
      };

      hostname = lib.mkOption {
        type = types.str;
        description = "Hostname served by the XMPP gateway, specified in the XMPP server as an external component.";
        default = "biboumi.local";
        # TODO: mandatory
      };

      password = lib.mkOption {
        type = types.str;
        description = "Password used to authenticate with the XMPP server, provided when specifying the external component.";
        # TODO: mandatory
      };

      serverIP = lib.mkOption {
        type = types.str;
        description = "XMPP server to connect to. (NOTE that all Biboumi XMPP traffic is unencrypted, so you shouldn't have to override this.)";
        default = "127.0.0.1";
      };

      port = lib.mkOption {
        type = types.port;
        description = "TCP port of the XMPP server to connect to for component communications.";
        default = 5347;
      };

      admins = lib.mkOption {
        type = types.listOf types.str;
        description = "JIDs of gateway administrators";
        default = [];
      };

      logLevel = lib.mkOption {
        type = types.enum [ 0 1 2 3 ];
        description = "Log level (0 = debug, 3 = error).";
        default = 1;
      };

      enableIdentd = lib.mkOption {
        type = types.bool;
        description = "Whether Biboumi should run its identd service (on the default port 113)";
        default = false;
      };

      extraConfig = lib.mkOption {
        type = types.str;
        description = "Extra configuration to append to the config file.";
        default = "";
      };

    };

  };


  ###### implementation

  config = let

    stateDirName = "biboumi";
    stateDir = "/var/lib/${stateDirName}";

    configFile = pkgs.writeText "biboumi.conf" ''
    hostname=${cfg.hostname}
    password=${cfg.password}
    xmpp_server_ip=${cfg.serverIP}
    port=${toString cfg.port}
    db_name=${stateDir}/biboumi.sqlite
    admin=${lib.concatStringsSep ":" cfg.admins}
    log_level=${toString cfg.logLevel}
    identd_port=${if cfg.enableIdentd then "133" else "0"}
    policy_directory=${cfg.package}/etc/biboumi
    '';

  in lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.biboumi = {
      description = "Biboumi XMPP-IRC gateway";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "prosody.service" "ejabberd.service" ];
      serviceConfig = {
        Type = "notify";
        DynamicUser = true;
        WatchdogSec = 20;
        Restart = "always";
        StateDirectory = stateDirName;
        RuntimeDirectory = "biboumi";
        ExecStart = "${cfg.package}/bin/biboumi ${lib.escapeShellArg configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -s USR1 $MAINPID";
        AmbientCapabilities =
          if cfg.enableIdentd
          then [ "CAP_NET_BIND_SERVICE" ]
          else [];
      };
    };
  };

}
