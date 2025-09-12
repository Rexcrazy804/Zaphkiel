{
  description = "Rexiel Scarlet's Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    hjem-impure.url = "github:Rexcrazy804/hjem-impure";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.smfh.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) getAttrs mapAttrs;

    pkgsFor = getAttrs (import systems) nixpkgs.legacyPackages;
    sources = import ./npins;
    moduleArgs = {
      inherit inputs self sources;
      inherit (nixpkgs) lib;
    };

    eachSystem = fn: mapAttrs fn pkgsFor;
    callModule = path: attrs: import path (moduleArgs // attrs);
  in {
    formatter = eachSystem (system: _: self.packages.${system}.irminsul);
    packages = eachSystem (system: pkgs: callModule ./pkgs {inherit system pkgs;});
    devShells = eachSystem (system: pkgs: callModule ./devShells {inherit system pkgs;});
    nixosConfigurations = callModule ./hosts {};
    templates = callModule ./templates {};
    nixosModules = callModule ./nixosModules/exported {};
  };
}
