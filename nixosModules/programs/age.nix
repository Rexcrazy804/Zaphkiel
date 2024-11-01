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

  age.identityPaths = builtins.map (username: "/home/${username}/.ssh/id_ed25519") users;
}
