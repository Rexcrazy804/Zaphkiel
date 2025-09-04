# sudo nixos-rebuild --no-reexec --file . -A nixosConfigurations.<hostName> <switch|boot|test|...>
# why? I wasted 3 weeks figuring this out, you are welcome :>
# see the Makefile for more commands
{
  sources ? {},
  sources' ? (import ./npins) // sources,
  nixpkgs ? sources'.nixpkgs,
  allowUnfree ? true,
  pkgs ? import nixpkgs {config = {inherit allowUnfree;};},
  quickshell ? null,
  useNpinsV6 ? true,
}:
pkgs.lib.fix (self: let
  inherit (pkgs.lib) mapAttrs callPackageWith warn;
  callPackage = callPackageWith (pkgs // self.packages);

  # WARNING
  # set useNpinsV6 to false if your sources are not v6
  # https://github.com/andir/npins?tab=readme-ov-file#using-the-nixpkgs-fetchers
  sources =
    if useNpinsV6
    then mapAttrs (k: v: v {inherit pkgs;}) sources'
    else sources';
in {
  overlays = {
    kurukurubar = _final: prev:
      if prev ? kurukurubar-overlay-present
      then {kurukurubar-overlay-present = 2;}
      else {
        kurukurubar-overlay-present = 1;
        inherit (self.packages) kurukurubar kurukurubar-unstable;
      };
  };

  packages = {
    inherit sources;

    # kurukuru
    quickshell = callPackage ./pkgs/quickshell.nix {inherit quickshell;};
    kurukurubar-unstable = callPackage ./pkgs/kurukurubar.nix {};
    kurukurubar = (self.packages.kurukurubar-unstable).override {
      inherit (pkgs) quickshell;
      # following zaphkiel master branch: quickshell v0.2.0
      # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
    };

    # trivial
    mpv-wrapped = callPackage ./pkgs/mpv {};
    librebarcode = callPackage ./pkgs/librebarcode.nix {};
    kokCursor = callPackage ./pkgs/kokCursor.nix {};
    npins = callPackage ./pkgs/npins.nix {};
    stash = callPackage (sources.stash + "/nix/package.nix") {};

    # package sets
    lanzaboote = callPackage ./pkgs/lanzaboote {};
    scripts = callPackage ./pkgs/scripts {};
    anime-launchers = callPackage ./pkgs/anime-launchers {};
    xvim = callPackage ./pkgs/nvim {};
    booru-images = callPackage ./pkgs/booru-images.nix {};

    # lib
    kokoLib = callPackage ./pkgs/kokoLib {};
    craneLib = callPackage (sources.crane + "/lib") {};

    # temp
    mbake = pkgs.mbake.overrideAttrs (_prev: {src = sources.bake;});
    # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
    # I had ditched the nixvim project long long long ago but the name just stuck
    nixvim-minimal = warn "Zahpkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self.packages.xvim.minimal;
    nixvim = warn "Zahpkiel: `nixvim` depricated please use xvim.default instead" self.packages.xvim.default;
  };

  nixosModules = {
    kurukuruDM = {
      imports = [./nixosModules/exported/kurukuruDM.nix];
      nixpkgs.overlays = [self.overlays.kurukurubar];
    };
    lanzaboote = {
      imports = [(sources.lanzaboote + "/nix/modules/lanzaboote.nix")];
      boot.lanzaboote.package = self.packages.lanzaboote.tool;
    };
  };

  devShells.default = callPackage ./devShells {};
  nixosConfigurations = callPackage ./hosts {};
})
