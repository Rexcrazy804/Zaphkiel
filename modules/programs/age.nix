{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs) agenix;
in {
  imports = [
    agenix.nixosModules.default
    (lib.mkAliasOptionModule ["zaphkiel" "secrets"] ["age" "secrets"])
  ];
  environment.systemPackages = [(agenix.packages.${system}.default)];
  age.identityPaths =
    ["/etc/ssh/ssh_host_ed25519_key"]
    ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519")
    config.zaphkiel.data.users;
}
