{
  lib,
  pkgs,
  config,
  ...
}: {
  _module.args.users = ["rexies" "sivanis"];
  imports = [
    ./hardware-configuration.nix
    ./user-configuration.nix
    ./extras/tinyproxy.nix
    ../../nixosModules/server-default.nix
    ../../users/rexies.nix
    ../../users/sivanis.nix
  ];

  boot.tmp.cleanOnBoot = true;
  networking.hostName = "Aphrodite";
  networking.domain = "divinity.org";

  networking = {
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

  # forward dns onto the tailnet
  networking = {
    nftables.enable = true;
    firewall = {
      interfaces."tailscale0" = {
        allowedTCPPorts = config.services.openssh.ports;
        allowedUDPPorts = [53];
      };
    };
  };
  services.dnscrypt-proxy2.settings = {
    listen_addresses = [
      "100.121.86.4:53"
      "[fd7a:115c:a1e0::6e01:5604]:53"
      "127.0.0.1:53"
      "[::1]:53"
    ];
  };

  servModule = {
    enable = true;
    tailscale = {
      enable = true;
      exitNode.enable = true;
      exitNode.networkDevice = "ens18";
    };
    openssh.enable = true;
    fail2ban.enable = false;
  };

  age.secrets.tailAuth.file = ../../secrets/secret8.age;
  services.tailscale.authKeyFile = config.age.secrets.tailAuth.path;

  services.openssh = {
    openFirewall = lib.mkForce false;
    startWhenNeeded = lib.mkForce false;
  };

  environment.systemPackages = [pkgs.git pkgs.nixvim];
  progModule.direnv.enable = true;

  system.stateVersion = "23.11";
}
