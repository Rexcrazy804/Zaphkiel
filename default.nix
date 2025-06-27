{...}: let
  sources = import ./npins;
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
}
