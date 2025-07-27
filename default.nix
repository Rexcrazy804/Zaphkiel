# TODO: use v6 format once that hits nixpkgs-unstable
{
  sources' ? import ./npins,
  system ? builtins.currentSystem,
  nixpkgs ? sources'.nixpkgs,
  pkgs ?
    import nixpkgs {
      inherit system;
    },
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
    packages = {
      mpv-wrapped = pkgs.callPackage ./pkgs/mpv {};
      librebarcode = pkgs.callPackage ./pkgs/librebarcode.nix {};
      kokCursor = pkgs.callPackage ./pkgs/kokCursor.nix {};

      # speening the kuru kuru
      kurukurubar-unstable = pkgs.callPackage ./pkgs/kurukurubar.nix {
        inherit quickshell;
        inherit (self.packages.scripts) gpurecording;
        inherit (self.packages) librebarcode;
      };
      kurukurubar = (self.packages.kurukurubar-unstable).override {
        inherit (pkgs) quickshell;
        configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
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

      booru-images = let
        imgBuilder = pkgs.callPackage (sources.booru-flake + "/nix/imgBuilder.nix");
      in (pkgs.lib.attrsets.mergeAttrsList (
        builtins.map (x: {${"i" + x.id} = imgBuilder x;}) (import ./nixosModules/programs/booru-flake/imgList.nix)
      ));

      # some cute scripts
      scripts = import ./pkgs/scripts {inherit (pkgs) lib callPackage;};
    };

    nixosModules.kurukuruDM = {...}: {
      imports = [./nixosModules/exported/kurukuruDM.nix];
      nixpkgs.overlays = [
        (final: prev: {
          inherit (self.packages) kurukurubar kurukurubar-unstable;
        })
      ];
    };
  })
