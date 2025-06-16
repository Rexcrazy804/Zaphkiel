{
  # don't ask me why
  description = "npins bridging flake template";
  inputs = {};
  outputs = {self, ...}: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    sources = import ./npins;

    # stolen from their original implimentations in nixpkg.lib
    nameValuePair = name: value: {inherit name value;};
    genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
    forAllSystems = f:
      genAttrs systems (
        system: f (import sources.nixpkgs {inherit system;})
      );
  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.hello;
    });
  };
}
