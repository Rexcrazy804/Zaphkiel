{
  sources,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    (sources.nix-minecraft + "/modules/minecraft-servers.nix")
    ./hollyj.nix
    ./backupservice.nix
  ];

  options.zaphkiel.services.minecraft.enable = lib.mkEnableOption "minecraft service";
  config = lib.mkIf (config.zaphkiel.services.minecraft.enable && config.zaphkiel.services.enable) {
    users.users.minecraft.packages = [pkgs.rconc];
    nixpkgs.overlays = [(import "${sources.nix-minecraft}/overlay.nix")];

    # allows geyser proxy for hollyj
    # WARN enable offline auth imperatively in the geyser config
    # will figure out a better way to do it later
    networking.firewall = {
      allowedUDPPorts = [19132];
      allowedTCPPorts = [8080];
    };

    # mongodb :< [EasyAuth]
    services.mongodb = {
      enable = true;
      package = pkgs.mongodb-ce;
    };

    services.minecraft-servers = {
      enable = true;
      eula = true;
      environmentFile = config.age.secrets.mcEnv.path;
    };

    age.secrets.mcEnv = {
      file = ../../../secrets/mc_rcon.age;
      owner = "minecraft";
    };
  };
}
