{
  pkgs,
  config,
  ...
}: {
  services.minecraft-servers = {
    servers.hollyj = {
      package = pkgs.fabricServers.fabric-1_21_4;
      enable = true;

      # start with: systemctl start minecraft-server-hollyj.service
      autoStart = true;
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
        enable-rcon = true;
        "rcon.port" = 8044;
        "rcon.password" = "@rcpwd@";
      };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          # API
          FabricApi = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/15ijyoD6/fabric-api-0.113.0%2B1.21.4.jar";
            hash = "sha256-V6sJzn/0qgbpZIjbjpbQynvHqjcRcNkVqaKmmamXRkU=";
          };
          ForgeConfigAPi = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ohNO6lps/versions/lTrPTmMK/ForgeConfigAPIPort-v21.4.1-1.21.4-Fabric.jar";
            hash = "sha256-Hh8uPw8DhbxwXDyrnvcaUyriKEC/ab9x1Kulj1lFbdY=";
          };

          # AUTH
          EasyAuth = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/aZj58GfX/versions/cNfqAFbs/easyauth-mc1.21.2-3.0.27.jar";
            hash = "sha256-YA4TWqmIZ7eXhgKM7eHsMmjU/YzvX4Wir+PHdZNaGqQ=";
          };

          # OPTIMIZATIONS
          C2ME = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/c8KSyi6D/c2me-fabric-mc1.21.4-0.3.1%2Brc.1.0.jar";
            hash = "sha256-0Z51G9Kn5npvQpaB1PmcPJa0OF3f5JxHCncMp4G+HFA=";
          };

          Krypton = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
            hash = "sha256-lPGVgZsk5dpk7/3J2hXN2Eg2zHXo/w/QmLq2vC9J4/4=";
          };

          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/t1FlWYl9/lithium-fabric-0.14.3%2Bmc1.21.4.jar";
            hash = "sha256-LJFVhw/3MnsPnYTHVZbM3xJtne1lV5twuYeqZSMZEn4=";
          };

          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/IPM0JlHd/ferritecore-7.1.1-fabric.jar";
            hash = "sha256-DdXpIDVSAk445zoPW0aoLrZvAxiyMonGhCsmhmMnSnk=";
          };

          AlternateCurrent = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/ponAdJiF/alternate-current-mc1.21.2-1.9.0.jar";
            hash = "sha256-qP6ZRyf5MIkgZl03XeJwjwMwqcA2kildKNY5QyAcPus=";
          };

          # Supected for Multiple Server Overloads .w.
          # ModernFix = pkgs.fetchurl {
          #   url = "https://cdn.modrinth.com/data/nmDcB62a/versions/gx7PIV8n/modernfix-fabric-5.20.1%2Bmc1.21.4.jar";
          #   hash = "sha256-yDjUaCH3wW/e5ccG4tpeO4JkMJScj8EbDSvQTlLVu+s=";
          # };

          # More Ram use .w. dk too lazy for this
          # Minecord = pkgs.fetchurl {
          #   url = "https://cdn.modrinth.com/data/DoVQa3oa/versions/VczzsOxU/minecord-2.1.0%2B1.21.3.jar";
          #   hash = "sha256-yDjUaCH3wW/e5ccG4tpeO4JkMJScj8EbDSvQTlLVu+s=";
          # };

          # CRASH
          # ScalableLux = pkgs.fetchurl {
          #   url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/DUpB8IQV/ScalableLux-0.1.1%2Bfabric.452731d-all.jar";
          #   hash = "sha256-8uzEKFYyi9z/XiiNdgiIkpgl3OSXREHP+7Q3vVz4dM4=";
          # };

          Slumber = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ksm6XRZ9/versions/FQF35QhU/slumber-1.3.0.jar";
            hash = "sha256-m3Y0n8I8SjAGFTNBMb6djHE9e+RPSF4tOT6Y3+10fHg=";
          };

          # UTILITY
          SkinRestorer = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/1ozhCpij/skinrestorer-2.2.1%2B1.21-fabric.jar";
            hash = "sha256-9f1yqKwzHeCcuDEP2JiwCXeRvwzWthiAbQ5O3FovJv4=";
          };

          UniversalGraves = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/yn9u3ypm/versions/o2f2Idvu/graves-3.6.0%2B1.21.4.jar";
            hash = "sha256-BStX6+EBPlmCpyZlEunBjy4E7DYc/EJCPCg0PnVSu9E=";
          };

          Pl3xMap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/34T8oVNY/versions/SdgU0i4e/Pl3xMap-1.21.4-520.jar";
            hash = "sha256-HvJpMK7esmPXo9aIacsNJ7QV4+uWGyOoX5DKIAPCNkY=";
          };

          OpenPartiesAndClaims = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gF3BGWvG/versions/fqPmcwfq/open-parties-and-claims-fabric-1.21.4-0.23.6.jar";
            hash = "sha256-qk4H5S5SGuZVB5FGs+1anSvMjT+XUXN9VLy7q7tn0PU=";
          };

          # TERRAIN
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
        });
      };
    };
  };
}
