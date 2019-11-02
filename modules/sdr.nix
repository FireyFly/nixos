{ config, lib, pkgs, ... }:

let
  cfg = config.mine;

in {
  options = {
    mine.enableSDR = lib.mkEnableOption "RTL-SDR support";
  };

  config = lib.mkIf cfg.enableSDR {
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
  # environment.systemPackages = [ pkgs.rtl-sdr ];
    services.udev.packages = [ pkgs.rtl-sdr ];
  };
}
