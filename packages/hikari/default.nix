{ stdenv, lib, fetchdarcs
# build dependencies
, bmake, pkg-config
# dependencies
, wayland, wayland-protocols, wlroots, libevdev, libinput, libxkbcommon
, pango, cairo, pixman, glib, libucl, openpam, pandoc
# options
, enableXWayland ? true
, enableScreencopy ? true
, enableGammaControl ? true
, enableLayerShell ? true
}:

stdenv.mkDerivation rec {
  pname = "hikari";
  version = "1.2.0";

  outputs = [ "out" "man" ];

  src = fetchdarcs {
    url = "https://hub.darcs.net/raichoo/${pname}";
    rev = version;
    sha256 = "02vysk3kv3r86w6bcrn3jfxkr4aigijk9jxndg7cgl7ihsgm7k4m";
  };

  nativeBuildInputs = [ bmake pkg-config pandoc ];
  buildInputs = [
    wayland wayland-protocols
    wlroots libinput libxkbcommon
    pango cairo glib libucl
    openpam
  ];

  makeFlags = [ "WITH_POSIX_C_SOURCE=YES" ]
    ++ (lib.optional enableXWayland "WITH_XWAYLAND=YES")
    ++ (lib.optional enableScreencopy "WITH_SCREENCOPY=YES")
    ++ (lib.optional enableGammaControl "WITH_GAMMACONTROL=YES")
    ++ (lib.optional enableLayerShell "WITH_LAYERSHELL=YES");
  makeFlagsStr = lib.concatStringsSep " " makeFlags;

  # Install these as non-setuid executables; we'll handle setuid wrapping separately.
  prePatch = "sed -i 's/-m 4555/-m 555/' Makefile";

  buildPhase = ''
    bmake PREFIX=$out ETC_PREFIX=$out/etc ${makeFlagsStr}
  '';

  installPhase = ''
    bmake PREFIX=$out ETC_PREFIX=$out/etc ${makeFlagsStr} install
  '';

  meta = let
    inherit (stdenv.lib) maintainers platforms licenses;
  in {
    description = "Wayland compositor and stacking+tiling window manager inspired by CWM";
    homepage = "https://hikari.acmelabs.space/";
    maintainers = [ maintainers.FireyFly ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
