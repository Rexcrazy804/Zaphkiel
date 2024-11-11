{
  inputs,
  pkgs,
  users,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];

  age.identityPaths =
    [
      "/etc/ssh/ssh_host_ed25519_key"
    ]
    ++ builtins.map (username: "/home/${username}/.ssh/id_ed25519") users;
}
