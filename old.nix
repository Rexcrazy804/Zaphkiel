{
  pkgs,
  system,
  lib,
  inputs,
  sources,
  ...
}:
lib.fix (self: let
  inherit (lib) warn;
  inherit (pkgs) callPackage;
in {
  # NOTE
  # for fingerprint to work in kurukuruDM,
  # you will need quickshell v0.2.1 minimum
  kurukurubar = callPackage ./kurukurubar.nix {inherit (self) librebarcode scripts;};
  kurukurubar-unstable = warn "kurukurubar-unstable depricated, use kurukurubar" self.kurukurubar;

  # trivial
  mpv-wrapped = callPackage ./mpv {};
  librebarcode = callPackage ./librebarcode.nix {};
  kokCursor = callPackage ./kokCursor.nix {};
  stash = inputs.stash.packages.${system}.default;
  irminsul = callPackage ./irminsul {inherit (self.scripts) qmlcheck;};
  dust-racing = callPackage ./dust-racing.nix {};
  equibop = callPackage ./equibop {};

  # mangowc simping
  mangowc-unwrapped = callPackage ./mangowc/unwrapped.nix {inherit sources;};
  mangowc = callPackage ./mangowc {inherit (self) mangowc-unwrapped;};

  # package sets
  scripts = callPackage ./scripts {};
  xvim = callPackage ./nvim {
    mnw = inputs.mnw.lib;
    inherit sources;
  };

  # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
  # I had ditched the nixvim project long long long ago but the name just stuck
  nixvim-minimal = warn "Zaphkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self.xvim.minimal;
  nixvim = warn "Zaphkiel: `nixvim` depricated please use `xvim.default` instead" self.xvim.default;
})
