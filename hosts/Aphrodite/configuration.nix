{lib, pkgs, config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules/server
    ../../nixosModules/nix
    ../../nixosModules/programs/age.nix
  ];

  boot.tmp.cleanOnBoot = true;
  networking.hostName = "Aphrodite";
  networking.domain = "divinity.org";
  networking = {
    nameservers = ["1.1.1.1, 1.0.0.1"];
    interfaces = {
      ens18.ipv4.addresses = [
        {
          address = "103.160.145.75";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "103.160.144.1";
      interface = "ens18";
    };
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "ens18";
    };
    openssh.enable = true;
    jellyfin.enable = false;
    minecraft.enable = false;
  };

  # tailscale
  age.secrets.tailAuth.file = ../../secrets/secret8.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  services.openssh.settings = {
    PasswordAuthentication = lib.mkForce true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git ripgrep fd;
  };

  system.stateVersion = "23.11";
}
