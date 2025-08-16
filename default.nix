# sudo nixos-rebuild --no-reexec --file . -A nixosConfigurations.<hostName> <switch|boot|test|...>
# why? I wasted 3 weeks figuring this out, you are welcome :>
# see the Makefile for more commands
{
  sources ? builtins.trace "Zaphkiel: USE `sources` INSTEAD OF `sources'`" {},
  # TODO remove the warning after 3 weeks
  # 2nd August, 2025
  sources' ? (import ./npins) // sources,
  nixpkgs ? sources'.nixpkgs,
  allowUnfree ? true,
  pkgs ? import nixpkgs {config = {inherit allowUnfree;};},
  quickshell ? null,
  useNpinsV6 ? true,
}:
pkgs.lib.fix (self: let
  inherit (pkgs.lib) mapAttrs attrValues callPackageWith warn;
  inherit (pkgs) mkShellNoCC;
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
    lix = import ./pkgs/overlays/lix.nix {lix = null;};
    # ensures that we don't add the overlay twice (straight up stolen from lix)
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

    # lib
    kokoLib = callPackage ./pkgs/kokoLib {};
    craneLib = callPackage (sources.crane + "/lib") {};

    # temp
    mbake = pkgs.mbake.overrideAttrs (_prev: {src = sources.bake;});
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

  devShells.default = let
    precommit = pkgs.writeShellScript "pre-commit" ''
      if make chk FILES_STAGED=1; then
        exit 0
      else
        make fmt FILES_STAGED=1
        exit 1
      fi
    '';
  in
    mkShellNoCC {
      shellHook = ''
        HOOKS=$(pwd)/.git/hooks
        if ! [ -f "$HOOKS/pre-commit" ]; then
          install ${precommit} $HOOKS/pre-commit
          echo "[SHELL] created precommit hook :>"
        elif ! cmp --silent $HOOKS/pre-commit ${precommit}; then
          install ${precommit} $HOOKS/pre-commit
          echo "[SHELL] updated precommit hook ^OwO^"
        fi
      '';
      packages = attrValues {
        # formatters
        inherit (pkgs) alejandra luaformatter mdformat;
        inherit (pkgs.qt6) qtdeclarative;
        # yes I had to fucking write this
        inherit (self.packages.scripts) qmlcheck;
        # yes I hadda fix this
        inherit (self.packages) mbake;
        # make the cutest
        inherit (pkgs) gnumake;
      };
    };

  nixosConfigurations = let
    nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
    overlays = attrValues {
      inherit (self.overlays) lix;
      internal = import ./pkgs/overlays/internal.nix;
      # for the people of the future,
      # if you don't understand why this was done,
      # just know I am a eval time racer
      # this saves 1.1 seconds of eval time
    };
    nixosHost = hostName:
      nixosSystem {
        system = null;
        specialArgs = {inherit sources;};
        modules = [
          {nixpkgs.overlays = overlays;}
          ./hosts/${hostName}/configuration.nix
          ./users/rexies.nix
          ./nixosModules
        ];
      };
  in {
    Persephone = nixosHost "Persephone";
    Seraphine = nixosHost "Seraphine";
    Aphrodite = nixosHost "Aphrodite";
  };
})
