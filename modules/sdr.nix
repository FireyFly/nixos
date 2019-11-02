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
    environment.systemPackages = with pkgs; [
      gqrx
      multimon-ng
      inspectrum
      sox
    # gnuradio
    # gnuradio-gsm
    # gnuradio-osmosdr
    # gnuradio-rds
    ];
  };
}
