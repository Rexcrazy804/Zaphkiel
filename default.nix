# TODO: use v6 format once that hits nixpkgs-unstable
{
  sources' ? import ./npins,
  system ? builtins.currentSystem,
  nixpkgs ? sources'.nixpkgs,
  pkgs ? import nixpkgs {inherit system;},
  quickshell ?
    pkgs.callPackage (sources'.quickshell {}) {
      gitRev = sources'.quickshell.revision;
    },
  mnw ? sources'.mnw,
}: let
  inherit (pkgs.lib) fix;
  # I wanna use a top level let in to remove the import ./npins redundancy but
  # that doesn't look cute so here we are .w.
  sources = (import ./npins) // sources';
in
  fix (self: {
    overlays = {
      kurukurubar = final: prev: {
        inherit (self.packages) kurukurubar kurukurubar-unstable;
      };
    };

    packages = {
      mpv-wrapped = pkgs.callPackage ./pkgs/mpv {};
      librebarcode = pkgs.callPackage ./pkgs/librebarcode.nix {};
      kokCursor = pkgs.callPackage ./pkgs/kokCursor.nix {};

      # WARNING
      # THIS WILL BUILD QUICKSHELL FROM SOURCE
      # you can find more information in the README
      kurukurubar-unstable = pkgs.callPackage ./pkgs/kurukurubar.nix {
        inherit quickshell;
        inherit (self.packages.scripts) gpurecording;
        inherit (self.packages) librebarcode;
      };
      kurukurubar = (self.packages.kurukurubar-unstable).override {
        # quickshell v0.2.0 (nixpkgs)
        inherit (pkgs) quickshell;

        # INFO
        # following zaphkiel master branch
        # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
      };

      nixvim-minimal = import ./pkgs/nvim.nix {
        inherit pkgs mnw;
      };
      nixvim = self.packages.nixvim-minimal.override (prev: {
        extraBinPath =
          prev.extraBinPath
          ++ [
            # language servers
            pkgs.nil
            pkgs.lua-language-server
            pkgs.kdePackages.qtdeclarative
            # formatter
            pkgs.alejandra
          ];
      });

      # the booru image collection
      booru-images = let
        imgBuilder = pkgs.callPackage (sources.booru-flake + "/nix/imgBuilder.nix");
      in (pkgs.lib.attrsets.mergeAttrsList (
        builtins.map (x: {${"i" + x.id} = imgBuilder x;}) (import ./nixosModules/programs/booru-flake/imgList.nix)
      ));

      # some cute scripts
      scripts = import ./pkgs/scripts {inherit (pkgs) lib callPackage;};

      # is your boot secure yet?
      lanzaboote = import ./pkgs/lanzaboote/default.nix {
        inherit (sources) nixpkgs rust-overlay crane lanzaboote;
      };
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
  })
