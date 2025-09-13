{
  description = "A minimal Flake template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    inherit (lib) getAttrs mapAttrs;

    moduleArgs = {inherit inputs self lib;};
    pkgsFor = getAttrs (import systems) nixpkgs.legacyPackages;

    callModule = path: attrs: import path (moduleArgs // attrs);
    eachSystem = fn: mapAttrs fn pkgsFor;
  in {
    formatter = eachSystem (_: pkgs: pkgs.alejandra);
    packages = eachSystem (system: pkgs: callModule ./nix/pkgs {inherit system pkgs;});
    devShells = eachSystem (system: pkgs: callModule ./nix/shells {inherit system pkgs;});
  };
}
