
self: super: {
  hikari = super.hikari.overrideAttrs ({ pname, ... }: {
    version = "dev";
    src = super.fetchdarcs {
      url = "https://hub.darcs.net/raichoo/${pname}";
      hash = "4a353f9db2deb9a8448454e57466e05127ccfbeb";
      sha256 = "1szkqskzc9i3la792sr3ljk0bplj22vlf3qmlw852dd9mskzm8x0";
    };
  });

  poezio = super.poezio.overrideAttrs ({ pname, ... }: {
    version = "0.13-dev";
    src = super.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "ed8f3b5c272cf045193a09cfe4df67c6a365f165";
      sha256 = "140b10idird83qd1fygry74baw8mp3hfkcxj90ggcr5d4vafsai9";
    };
  });
}
