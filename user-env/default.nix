{ pkgs, ... }:

pkgs.buildEnv {
  name = "firefly-user-env";
  pathsToLink = [ "/bin" "/share/man" ];
  extraOutputsToInstall = [ "doc" "man" ];

  paths = with pkgs; [
    manpages
    # standard tools
    bc file htop psmisc tree
    # utilities
    plaintext charselect
    (up.override {
      clipboardCommand =
        "${wl-clipboard}/bin/wl-copy";
      # if config.services.xserver.enable
      # then "${xclip}/bin/xcilp -selection clipboard -i"
      # else if config.programs.hikari.enable
      # then "${wl-clipboard}/bin/wl-copy"
      # else "cat";
    })
    # network
   #bind
    finger_bsd lftp whois
    mosh wget
    # compression
    unzip zip
    # reveng etc
    hexd pixd colordiff vbindiff
    # useful tools
    w3m jq ripgrep xmlformat
    j
    (import ./vim { inherit pkgs; })
    git
  ];
}
