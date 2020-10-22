
self: super: {
  poezio = super.poezio.overrideAttrs ({ pname, ... }: {
    version = "0.13-dev";
    src = super.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "ed8f3b5c272cf045193a09cfe4df67c6a365f165";
      sha256 = "140b10idird83qd1fygry74baw8mp3hfkcxj90ggcr5d4vafsai9";
    };
  });

  dino = super.dino.overrideAttrs ({ pname, ... }: {
    version = "0.1.0-dev";
    src = super.fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "5954f7764f239d213ae5b30887994f4af535b81f";
      sha256 = "0j6l30ijrwvl6mpsyfwzaq0vlp3ba4f37k93fgkazh0n63ky2qvy";
    };
  });
}
