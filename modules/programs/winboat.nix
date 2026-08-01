{
  dandelion.modules.winboat = {pkgs, ...}: {
    virtualisation.docker.enable = true;
    environment.systemPackages = [pkgs.winboat];
    users.users.rexies.extraGroups = ["docker"];

    # remove this once fixed upstream
    nixpkgs.config.permittedInsecurePackages = [
      "electron-40.10.5"
    ];
  };
}
