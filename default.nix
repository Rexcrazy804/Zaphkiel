{...}: let
  sources = import ./npins;
  overlays = {
    internal = import ./pkgs/overlays/internal.nix {inherit sources;};
    lix = import ./pkgs/overlays/lix.nix {lix = null;};
    lix-regfix = import ./pkgs/overlays/lix-regression-fix.nix;
  };
in {
  _module.args = {inherit sources;};
  imports = [
    ./hosts/${builtins.getEnv "HOSTNAME"}/configuration.nix
    (sources.agenix + "/modules/age.nix")
    (sources.hjem + "/modules/nixos")
    (sources.aagl + "/module")
    (sources.booru-flake + "/nix/nixosModule.nix")
    (sources.nix-minecraft + "/modules/minecraft-servers.nix")
  ];

  nixpkgs = {
    overlays = builtins.attrValues overlays;
  };
}
