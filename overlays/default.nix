
[
  (import ./packages/overlay.nix)
  (import ./pins.nix)
  (import ./patches/overlay.nix)

  (self: super: {
    waybar = super.waybar.override {
      pulseSupport = true;
      swaySupport = false;
    };

    hikari = super.hikari.overrideAttrs ({ patches ? [], ... }: {
      patches = patches ++ [ ./patches/hikari.patch ];
    });

    # patch out the Esc->Caps transform (pass through Esc unchanged)
    interception-tools-plugins = super.interception-tools-plugins // {
      caps2esc = super.interception-tools-plugins.caps2esc.overrideAttrs (_: {
        prePatch = ''
          sed -i '
            /if (input.code == KEY_ESC)/ d
            /input.code = KEY_CAPSLOCK;/ d
          ' caps2esc.c
        '';
      });
    };
  })

  (import ./configurable)
]
