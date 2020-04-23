{ config, lib, pkgs, ... }:

let
  cfg = config.mine;

in {
  options = {
    mine.enableSDR = lib.mkEnableOption "RTL-SDR support";
  };

  config = lib.mkIf cfg.enableSDR {
    boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" ];
    services.udev.packages = [ pkgs.rtl-sdr ];
    environment.systemPackages = [
      pkgs.gqrx
      pkgs.multimon-ng
      pkgs.inspectrum
      pkgs.sox
    ];
  };
}
