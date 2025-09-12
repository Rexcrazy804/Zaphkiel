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
  # kurukuru
  quickshell = import ./quickshell.nix {
    inherit (inputs.quickshell) rev;
    inherit
      (inputs.quickshell.packages.${system})
      quickshell
      ;
  };
  kurukurubar-unstable = callPackage ./kurukurubar.nix {
    inherit (self) quickshell;
    inherit (self) librebarcode scripts;
  };
  kurukurubar = (self.kurukurubar-unstable).override {
    inherit (pkgs) quickshell;
    # following zaphkiel master branch: quickshell v0.2.0
    # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
  };

  # trivial
  mpv-wrapped = callPackage ./mpv {};
  librebarcode = callPackage ./librebarcode.nix {};
  kokCursor = callPackage ./kokCursor.nix {};
  stash = inputs.stash.packages.${system}.default;
  irminsul = callPackage ./formatters {inherit (self.scripts) qmlcheck;};

  # package sets
  scripts = callPackage ./scripts {};
  xvim = callPackage ./nvim {
    mnw = inputs.mnw.lib;
    inherit sources;
  };

  # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
  # I had ditched the nixvim project long long long ago but the name just stuck
  nixvim-minimal = warn "Zahpkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self.xvim.minimal;
  nixvim = warn "Zahpkiel: `nixvim` depricated please use `xvim.default` instead" self.xvim.default;
})
