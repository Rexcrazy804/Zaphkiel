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
    inherit (nixpkgs) lib;
    inherit (lib) genAttrs;

    systems = import inputs.systems;
    sources = import ./npins;
    callModule = {
      __functor = self: path: attrs: import path (self // attrs);
      inherit inputs self lib sources;
    };

    pkgsFor = system: nixpkgs.legacyPackages.${system};
    eachSystem = fn: genAttrs systems (system: fn (pkgsFor system));
    # TODO
    # npins v6, switch to this once v6 hits nixpkgs-unstable
    # sources = pkgs: mapAttrs (k: v: v {inherit pkgs;}) pins;
  in {
    formatter = eachSystem (pkgs: pkgs.alejandra);
    packages = eachSystem (pkgs: callModule ./pkgs {inherit pkgs;});
    nixosConfigurations = callModule ./hosts {};
    templates = callModule ./templates {};

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
  };
}
