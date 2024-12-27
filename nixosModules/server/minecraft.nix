{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

  options = {
    servModule.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
    };
  };

  config = lib.mkIf (config.servModule.minecraft.enable && config.servModule.enable) {
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    # allows geyser proxy for hollyj
    # WARN enable offline auth imperatively in the geyser config
    # will figure out a better way to do it later
    networking.firewall = {
      allowedUDPPorts = [19132];
    };
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers = {
        hollyj = {
          package = pkgs.fabricServers.fabric-1_21_4;
          enable = true;
          # start with: systemctl start minecraft-server-hollyj.service
          autoStart = false;
          openFirewall = true;
          enableReload = true;
          restart = "no";
          jvmOpts =
            builtins.concatStringsSep
            " "
            [
              "-Xms1024M"
              "-Xmx6144M"
            ];

          serverProperties = {
            server-port = 8043;
            difficulty = "normal";
            max-players = 20;
            enforce-secure-profile = false;
            online-mode = false;
            motd = "Prepare Za Balls";
          };

          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              FabricApi = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/15ijyoD6/fabric-api-0.113.0%2B1.21.4.jar";
                hash = "sha256-V6sJzn/0qgbpZIjbjpbQynvHqjcRcNkVqaKmmamXRkU=";
              };


              C2ME = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/VSNURh3q/versions/c8KSyi6D/c2me-fabric-mc1.21.4-0.3.1%2Brc.1.0.jar";
                hash = "sha256-0Z51G9Kn5npvQpaB1PmcPJa0OF3f5JxHCncMp4G+HFA=";
              };

              Krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
                hash = "sha256-lPGVgZsk5dpk7/3J2hXN2Eg2zHXo/w/QmLq2vC9J4/4=";
              };

              Geyser = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/5fXHHtpx/geyser-fabric-Geyser-Fabric-2.6.0-b738.jar";
                hash = "sha256-P2n2vUfpQXSXs3XiFqabMnkoDtStXrtidcryrsRNrzE=";
              };

              Lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/t1FlWYl9/lithium-fabric-0.14.3%2Bmc1.21.4.jar";
                hash = "sha256-LJFVhw/3MnsPnYTHVZbM3xJtne1lV5twuYeqZSMZEn4=";
              };

              FerriteCore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
                hash = "sha256-DdXpIDVSAk445zoPW0aoLrZvAxiyMonGhCsmhmMnSnk=";
              };

              SkinRestorer = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/1ozhCpij/skinrestorer-2.2.1%2B1.21-fabric.jar";
                hash = "sha256-9f1yqKwzHeCcuDEP2JiwCXeRvwzWthiAbQ5O3FovJv4=";
              };

              Terralith = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/lQreFvOm/Terralith_1.21.x_v2.5.7.jar";
                hash = "sha256-4Si09xC+/m78i2cMzMrF6H6TZXlns27DSouA+DlO6s0=";
              };

              NullScape = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/LPjGiSO4/versions/dHJAVX8s/Nullscape_1.21.x_v1.2.10.jar";
                hash = "sha256-DaR0Vv8+o4Nd8B14qCjtuvryDc/tfXf6Ntg1T4dmys4=";
              };

              Incendium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/ZVzW5oNS/versions/7mVvV9Th/Incendium_1.21.x_v5.4.4.jar";
                hash = "sha256-KFpPaf4jkfIXX3/JMW1yejnHm90hSSPFkoTVabzmVvQ=";
              };

              UniversalGraves = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/yn9u3ypm/versions/o2f2Idvu/graves-3.6.0%2B1.21.4.jar";
                hash = "sha256-BStX6+EBPlmCpyZlEunBjy4E7DYc/EJCPCg0PnVSu9E=";
              };
            });
          };
        };
      };
    };
  };
}
