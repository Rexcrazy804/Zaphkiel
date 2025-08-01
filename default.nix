{
  sources' ? import ./npins,
  system ? builtins.currentSystem,
  nixpkgs ? sources'.nixpkgs,
  pkgs ? import nixpkgs {inherit system;},
  quickshell ?
    pkgs.callPackage (sources'.quickshell {inherit pkgs;}) {
      gitRev = sources'.quickshell.revision;
      withJemalloc = true;
      withQtSvg = true;
      withWayland = true;
      withX11 = false;
      withPipewire = true;
      withPam = true;
      withHyprland = true;
      withI3 = false;
    },
}: let
  inherit (pkgs.lib) fix mapAttrs attrValues makeScope;
  inherit (pkgs) newScope;
  # I wanna use a top level let in to remove the import ./npins redundancy but
  # that doesn't look cute so here we are .w.
  # https://github.com/andir/npins?tab=readme-ov-file#using-the-nixpkgs-fetchers
  # TODO: figure out if we should check if they are the same before mergin (optimization maybe)?
  sources = mapAttrs (k: v: v {inherit pkgs;}) ((import ./npins) // sources');
in
  fix (self: {
    overlays = {
      kurukurubar = final: prev: {inherit (self.packages) kurukurubar kurukurubar-unstable;};
      lix = import ./pkgs/overlays/lix.nix {lix = null;};
      internal = import ./pkgs/overlays/internal.nix;
    };

    packages = makeScope newScope (self': let
      inherit (self') callPackage;
    in {
      mpv-wrapped = callPackage ./pkgs/mpv {};
      librebarcode = callPackage ./pkgs/librebarcode.nix {};
      kokCursor = callPackage ./pkgs/kokCursor.nix {};

      npins = callPackage (sources.npins + "/npins.nix") {};

      # WARNING
      # THIS WILL BUILD QUICKSHELL FROM SOURCE
      # you can find more information in the README
      kurukurubar-unstable = callPackage ./pkgs/kurukurubar.nix {inherit quickshell;};
      kurukurubar = (self'.kurukurubar-unstable).override {
        # quickshell v0.2.0 (nixpkgs)
        inherit (pkgs) quickshell;

        # INFO
        # following zaphkiel master branch
        # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
      };

      nixvim-minimal = import ./pkgs/nvim.nix {
        inherit (sources) mnw;
        inherit pkgs;
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
        imgBuilder = callPackage (sources.booru-flake + "/nix/imgBuilder.nix");
      in (pkgs.lib.attrsets.mergeAttrsList (
        builtins.map (x: {${"i" + x.id} = imgBuilder x;}) (import ./nixosModules/programs/booru-flake/imgList.nix)
      ));

      # some cute scripts
      scripts = import ./pkgs/scripts {
        inherit (pkgs) lib;
        inherit (self') callPackage;
      };

      # is your boot secure yet?
      lanzaboote = import ./pkgs/lanzaboote/default.nix {
        inherit (sources) nixpkgs rust-overlay crane lanzaboote;
      };
    });

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

    nixosConfigurations = let
      nixosConfig = hostName:
        import (nixpkgs + "/nixos/lib/eval-config.nix") {
          system = null;
          specialArgs = {inherit self sources;};
          modules = [
            {nixpkgs.overlays = attrValues self.overlays;}
            ./hosts/${hostName}/configuration.nix
            ./users/rexies.nix
            ./nixosModules
          ];
        };
    in {
      Persephone = nixosConfig "Persephone";
      Seraphine = nixosConfig "Seraphine";
      Aphrodite = nixosConfig "Aphrodite";
    };
  })
