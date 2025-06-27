{
  sources,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (sources) nix-minecraft;
in {
  imports = [
    "${nix-minecraft}/modules/minecraft-servers.nix"
    ./hollyj.nix
    ./backupservice.nix
  ];

  options = {
    servModule.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
    };
  };

  config = lib.mkIf (config.servModule.minecraft.enable && config.servModule.enable) {
    users.users.minecraft.packages = [pkgs.rconc];
    nixpkgs.overlays = [(import "${nix-minecraft}/overlay.nix")];

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
