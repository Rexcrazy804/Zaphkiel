{
  description = "Rexiel Scarlet's Flake bridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    quickshell = {
      url = "github:Rexcrazy804/quickshell?ref=overridable-qs-unwrapped";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stash = {
      url = "github:notashelf/stash";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs mapAttrs;

    systems = import inputs.systems;
    eachSystem = system: nixpkgs.legacyPackages.${system};
    pkgsFor = fn: genAttrs systems (system: fn (eachSystem system));
    pins = import ./npins;
    sources = pkgs: mapAttrs (k: v: v {inherit pkgs;}) pins;
  in {
    formatter = pkgsFor (pkgs: pkgs.alejandra);

    packages = pkgsFor (pkgs:
      import ./pkgs {
        inherit pkgs inputs;
        sources = sources pkgs;
      });
    # some code duplication here but its better that we do this rather than get
    # it through the default.nix due to infinite recursion reasons
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
