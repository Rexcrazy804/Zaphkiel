{
  description = "Rexiel Scarlet's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.smfh.follows = "";
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

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    pkgsFor = lib.getAttrs (import systems) nixpkgs.legacyPackages;
    sources = import ./npins;
    moduleArgs = {inherit inputs self sources lib;};

    eachSystem = fn: lib.mapAttrs (system: pkgs: fn {inherit system pkgs;}) pkgsFor;
    callModule = path: attrs: import path (moduleArgs // attrs);
  in {
    formatter = eachSystem ({system, ...}: self.packages.${system}.irminsul);
    packages = eachSystem (attrs: callModule ./pkgs attrs);
    devShells = eachSystem (attrs: callModule ./devShells attrs);
    nixosConfigurations = callModule ./hosts {};
    templates = callModule ./templates {};
    nixosModules = callModule ./nixosModules/exported {};
  };
}
