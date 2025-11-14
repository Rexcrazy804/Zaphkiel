{
  dandelion.modules.winboat = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    environment.systemPackages = [pkgs.package];
    users.users.rexies.extraGroups = ["docker"];
  };
}
