{...}: let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {};
  overlays = {
    internal = import ./pkgs/overlays/internal.nix {inherit sources;};
    lix = import ./pkgs/overlays/lix.nix {lix = null;};
    npins = import ./pkgs/overlays/npins.nix;
  };
in {
  _module.args = {inherit sources;};
  imports = [
    ./hosts/${builtins.getEnv "HOSTNAME"}/configuration.nix
    (sources.agenix {inherit pkgs;} + "/modules/age.nix")
    (sources.hjem {inherit pkgs;} + "/modules/nixos")
    (sources.aagl {inherit pkgs;} + "/module")
    (sources.booru-flake {inherit pkgs;} + "/nix/nixosModule.nix")
    (sources.nix-minecraft {inherit pkgs;} + "/modules/minecraft-servers.nix")
  ];

  nixpkgs.overlays = builtins.attrValues overlays;
}
