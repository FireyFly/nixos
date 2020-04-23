[
  ./secrets.nix

  # system profiles
  ./profiles/common.nix
  ./profiles/laptop.nix

  # modules
  ./config/user-environment.nix
  ./biboumi.nix

  # shared system config
  ./user.nix
  ./xserver
  ./sdr.nix

  # per-software config
  ./herbstluftwm
]
