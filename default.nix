{
  sources' ? {},
  sources'' ? (import ./npins) // sources',
  system ? builtins.currentSystem,
  nixpkgs ? sources''.nixpkgs,
  pkgs ? import nixpkgs {inherit system;},
  quickshell ? null,
}: let
  inherit (pkgs.lib) fix mapAttrs attrValues makeScope;
  inherit (pkgs) newScope;

  # WARNING
  # assuming sources' is npins v6 >.<
  # https://github.com/andir/npins?tab=readme-ov-file#using-the-nixpkgs-fetchers
  sources = mapAttrs (k: v: v {inherit pkgs;}) sources'';
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
      quickshell =
        if (quickshell == null)
        then
          callPackage (sources.quickshell) {
            gitRev = sources.quickshell.revision;
            withJemalloc = true;
            withQtSvg = true;
            withWayland = true;
            withX11 = false;
            withPipewire = true;
            withPam = true;
            withHyprland = true;
            withI3 = false;
          }
        else quickshell;

      mpv-wrapped = callPackage ./pkgs/mpv {};
      librebarcode = callPackage ./pkgs/librebarcode.nix {};
      kokCursor = callPackage ./pkgs/kokCursor.nix {};

      npins = callPackage (sources.npins + "/npins.nix") {};

      # WARNING
      # THIS WILL BUILD QUICKSHELL FROM SOURCE
      # you can find more information in the README
      kurukurubar-unstable = callPackage ./pkgs/kurukurubar.nix {};
      # INFO
      # following zaphkiel master branch
      # quickshell v0.2.0 (nixpkgs)
      kurukurubar = (self'.kurukurubar-unstable).override {
        inherit (pkgs) quickshell;
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
      scripts = callPackage ./pkgs/scripts {};

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
