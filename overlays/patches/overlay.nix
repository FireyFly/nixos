self: super:

rec {
  dino = super.dino.overrideAttrs ({ patches ? [], ... }: {
    patches = [
      ./0001-add-an-option-to-enable-omemo-by-default-in-new-conv.patch
    ];
  });
}
