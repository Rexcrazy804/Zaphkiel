{
  description = "Rexiel Scarlet's Flake";

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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs self;
    inherit (nixpkgs) lib;

    systems = import inputs.systems;
    sources = import ./npins;
    callModule = {
      __functor = self: path: attrs: import path (self // attrs);
      inherit inputs self lib sources;
    };

    pkgsFor = system: nixpkgs.legacyPackages.${system};
    eachSystem = fn: lib.genAttrs systems (system: fn (pkgsFor system));
  in {
    formatter = eachSystem (pkgs: self.packages.${pkgs.system}.irminsul);
    packages = eachSystem (pkgs: callModule ./pkgs {inherit pkgs;});
    nixosConfigurations = callModule ./hosts {};
    templates = callModule ./templates {};
    nixosModules = callModule ./nixosModules/exported {};
  };
}
