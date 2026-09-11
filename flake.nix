{
  description = "Rexiel Scarlet's Flake";

  # In search of beauty I found simplicity.
  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs filesystem;

    pkgsOf = nixpkgs.legacyPackages;
    eachSystem = genAttrs (import systems);
  in {
    formatter = eachSystem (system: self.legacyPackages.${system}.irminsul);

    devShells = eachSystem (system: {
      default = pkgsOf.${system}.callPackage ./flake/devshell.nix {
        inherit (self.legacyPackages.${system}) irminsul;
      };
    });

    legacyPackages = eachSystem (system:
      filesystem.packagesFromDirectoryRecursive {
        inherit (pkgsOf.${system}) newScope callPackage;
        directory = ./pkgs;
      });

    packages = eachSystem (system: let
      pkgs = pkgsOf.${system};
      stp = inputs.stash.packages.${system}.default;
    in {
      hjem-cli = inputs.hjem.packages.${system}.hjem;
      equibop = pkgs.equibop;

      xvim = pkgs.callPackage ./flake/packages/xvim {
        inherit (self.legacyPackages.${system}) sources;
        mnw = inputs.mnw.lib;
      };

      stash = pkgs.symlinkJoin {
        inherit (stp) meta version pname;
        paths = [stp];
        postBuild = ''
          rm $out/bin/wl-copy
          rm $out/bin/wl-paste
        '';
      };
    });

    nixosModules = {
      kurukuruDM = {pkgs, ...}: {
        imports = [./flake/nixosModules/kurukuruDM.nix];
        # TODO this is ugly, just write to the option directly with mkDefault
        nixpkgs.overlays = [
          (_: _: {
            inherit (self.legacyPackages.${pkgs.stdenv.hostPlatform.system}) kurukurubar;
          })
        ];
      };
      default = self.nixosModules.kurukuruDM;
    };

    nixosConfigurations = let
      inherit (nixpkgs.lib) nixosSystem mkOption types;

      hosts = ["aphrodite" "flora" "persephone" "seraphine"];
      flakeOpt = {
        options.flake = mkOption {
          type = types.attrs;
          default = self;
        };
        options.flake-inputs = mkOption {
          type = types.attrs;
          default = inputs;
        };
      };
    in
      genAttrs hosts (hostName: nixosSystem {modules = [./modules/hosts/${hostName} flakeOpt];});

    paths = {
      dots = ./dots;
      secrets = ./secrets;
      modules = ./modules;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    rexies-nix-templates.url = "git+https://iris.radicle.network/z3NZwrezFXNuUTHfazunz9BTygnHF";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };
    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    booru-hs = {
      url = "github:Rexcrazy804/booru.hs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    stash = {
      url = "github:notashelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.systems.follows = "systems";
    };
    hs-todo = {
      url = "github:Rexcrazy804/haskell-todo";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };
}
