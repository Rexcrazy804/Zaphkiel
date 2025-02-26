{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules/server
    ../../nixosModules/nix
    ../../nixosModules/programs/age.nix
    ../../nixosModules/system/networking/dnsproxy2.nix
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

  services.openssh = {
    openFirewall = lib.mkForce false;
    startWhenNeeded = lib.mkForce false;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git;
    nixvim = pkgs.wrappedPkgs.nvim-wrapped;
  };

  progModule.direnv.enable = true;

  system.stateVersion = "23.11";
}
