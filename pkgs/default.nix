{
  pkgs,
  inputs,
  sources,
  ...
}:
pkgs.lib.fix (self: let
  inherit (pkgs.lib) callPackageWith warn;
  inherit (pkgs) system;
  callPackage = callPackageWith (pkgs // self);
in {
  # currently only required for nvim Plugins
  inherit sources;

  # kurukuru
  quickshell = import ./quickshell.nix {
    inherit
      (inputs.quickshell.packages.${pkgs.system})
      quickshell
      quickshell-unwrapped
      ;
  };
  kurukurubar-unstable = callPackage ./kurukurubar.nix {};
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

  # package sets
  lanzaboote = callPackage ./lanzaboote {};
  scripts = callPackage ./scripts {};
  xvim = callPackage ./nvim {mnw = inputs.mnw.lib;};
  booru-images = callPackage ./booru-images.nix {
    inherit (inputs.booru-flake.packages.${system}) imgBuilder;
  };

  # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
  # I had ditched the nixvim project long long long ago but the name just stuck
  nixvim-minimal = warn "Zahpkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self.xvim.minimal;
  nixvim = warn "Zahpkiel: `nixvim` depricated please use xvim.default instead" self.xvim.default;
})
