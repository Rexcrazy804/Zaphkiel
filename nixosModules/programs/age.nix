{
  sources,
  config,
  pkgs,
  ...
}: {
  imports = [(sources.agenix + "/modules/age.nix")];
  environment.systemPackages = [(pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})];
  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"] ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") config.zaphkiel.data.users;
}
