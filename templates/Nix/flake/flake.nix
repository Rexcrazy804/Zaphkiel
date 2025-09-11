{
  description = "A minimal Flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs self;
    inherit (nixpkgs) lib;

    systems = import inputs.systems;
    sources = import ./npins;
    moduleArgs = {inherit inputs self lib sources;};

    callModule = path: attrs: import path (moduleArgs // attrs);
    pkgsFor = system: nixpkgs.legacyPackages.${system};
    eachSystem = fn: lib.genAttrs systems (system: fn (pkgsFor system));
  in {
    formatter = eachSystem (pkgs: pkgs.alejandra);
    packages = eachSystem (pkgs: callModule ./nix/pkgs {inherit pkgs;});
    devShells = eachSystem (pkgs: callModule ./nix/shells {inherit pkgs;});
  };
}
