[
  # generic support modules
  ./config/user-environment.nix

  # system profiles
  ./profiles/common.nix
  ./profiles/laptop.nix

  # modules
  ./biboumi.nix

  # shared system config
  ./user.nix
  ./xserver
  ./sdr.nix

  # per-software config
  ./herbstluftwm
]
