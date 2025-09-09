{
  description = "Rexiel Scarlet's Flake bridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    hjem-impure.url = "github:Rexcrazy804/hjem-impure";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.smfh.follows = "";
    };
    quickshell = {
      url = "github:Rexcrazy804/quickshell?ref=overridable-qs-unwrapped";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stash = {
      url = "github:notashelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
    booru-flake = {
      url = "github:Rexcrazy804/booru-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs mapAttrs;

    systems = import inputs.systems;
    pins = import ./npins;

    pkgsFor = system: nixpkgs.legacyPackages.${system};
    eachSystem = fn: genAttrs systems (system: fn (pkgsFor system));
    sources = pkgs: mapAttrs (k: v: v {inherit pkgs;}) pins;
  in {
    formatter = eachSystem (pkgs: pkgs.alejandra);

    packages = eachSystem (pkgs:
      import ./pkgs {
        inherit pkgs inputs;
        sources = sources pkgs;
      });

    nixosConfigurations = {
      Persephone = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs sources;
          mein = self.packages;
        };
        modules = [
          ./hosts/Persephone/configuration.nix
          ./nixosModules
          ./users/rexies.nix
        ];
      };
    };

    nixosModules = {
      kurukuruDM = {
        pkgs,
        lib,
        ...
      }: {
        imports = [./nixosModules/exported/kurukuruDM.nix];

        nixpkgs.overlays = [
          (final: prev: {inherit (self.packages.${pkgs.system}) kurukurubar kurukurubar-unstable;})
        ];
      };
    };

    templates = import ./templates;
  };
}
