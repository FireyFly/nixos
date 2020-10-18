
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
}
