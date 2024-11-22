{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  options = {
    servModule.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
    };
  };

  config = lib.mkIf (config.servModule.minecraft.enable && config.servModule.enable) {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        HolyJ = {
          package = pkgs.fabricServers.fabric-1_21_3;
          enable = true;
          autoStart = false;
          openFirewall = true;
          enableReload = true;

          serverProperties = {
            server-port = 43000;
            difficulty = "normal";
            max-players = 20;
            motd = "Prepare Za Balls";
          };

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              Terralith = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/81gyNzd0/Terralith_1.21.x_v2.5.6.jar";
                hash = "";
              };

              C2ME = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/VSNURh3q/versions/tV8Sxjfg/c2me-fabric-mc1.21.3-0.3.0%2Bbeta.2.0.jar";
                hash = "";
              };

              Krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
                hash = "";
              };

              Lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/QhCwdt4l/lithium-fabric-0.14.2-snapshot%2Bmc1.21.3-build.91.jar";
                hash = "";
              };

              FerriteCore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/a3QXXGz2/ferritecore-7.1.0-hotfix-fabric.jar";
                hash = "";
              };
            });
          };
        };
      };
    };
  };
}
