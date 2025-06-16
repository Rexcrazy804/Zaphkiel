{
  description = "npins flake compat layer";
  inputs = {};
  outputs = {self, ...}: let
    sources = import ./npins;
    # npins add git https://git.lix.systems/lix-project/flake-compat --branch=main
    compat = src: (import sources.flake-compat {inherit src;}).outputs;
    nixpkgs = compat sources.nixpkgs;

    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (
        system: f (import nixpkgs {inherit system;})
      );
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.hello;
    });
  };
}
