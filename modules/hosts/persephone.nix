{
  self,
  booru-hs,
  ...
}: {
  dandelion.hosts.Persephone = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      self.dandelion.profiles.mangowc
      self.dandelion.users.rexies
      self.dandelion.hardware.persephone
      self.dandelion.modules.fingerprint
      self.dandelion.modules.btrfs
      self.dandelion.modules.sunshine
      self.dandelion.modules.tpm
      self.dandelion.modules.printing
      self.dandelion.modules.kuruDM
      self.dandelion.modules.kuruDM-mango
      self.dandelion.modules.winboat
      self.dandelion.modules.keyd
      self.dandelion.modules.firefox
      self.dandelion.modules.gnupg
      self.dandelion.modules.matugen
      self.dandelion.modules.hjem-games
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";
    networking.hostName = "Persephone";
    time.timeZone = "Asia/Dubai";

    zaphkiel = {
      data.wallpaper = pkgs.fetchurl {
        url = "https://cdn.donmai.us/original/8c/5d/__rubuska_and_corvus_reverse_1999__8c5da40a6b3a247b20327f0c0d71d2b9.jpg";
        hash = "sha256-Gzk5CRaMnu5WJUvg3SUpnS15FdrPvONcN5bBRdxIFtY=";
      };
      programs.matugen.scheme = "scheme-fidelity";
      utils.btrfs-snapshots.rexies = [
        {
          subvolume = "Documents";
          calendar = "daily";
          expiry = "1d";
        }
        {
          subvolume = "Music";
          calendar = "weekly";
          expiry = "3w";
        }
        {
          subvolume = "Pictures";
          calendar = "weekly";
          expiry = "3w";
        }
      ];
    };

    # forward dns onto the tailnet
    networking.firewall.allowedTCPPorts = [53];
    networking.firewall.allowedUDPPorts = [53];
    services.dnscrypt-proxy.settings = {
      listen_addresses = [
        "100.110.70.18:53"
        "[fd7a:115c:a1e0::6a01:4614]:53"
        "127.0.0.1:53"
        "[::1]:53"
      ];
    };

    hardware.bluetooth.powerOnBoot = lib.mkForce false;
    powerManagement.powertop.enable = true;
    # multi-user.target shouldn't wait for powertop
    systemd.services.powertop.serviceConfig.Type = lib.mkForce "exec";
    # disable network manager wait online service (+6 seconds to boot time!!!!)
    systemd.services.NetworkManager-wait-online.enable = false;

    users.users."rexies" = {
      packages = lib.attrValues {
        # wine
        inherit (pkgs.wineWowPackages) waylandFull;
        inherit (pkgs.heroic-unwrapped) legendary;
        inherit (pkgs) bottles winetricks mono umu-launcher;
        # terminal
        inherit (pkgs) foot libsixel;

        # from exported packages
        inherit (self.packages.${pkgs.system}) mpv-wrapped equibop;
        inherit (self.packages.${pkgs.system}.scripts) wallcrop legumulaunch;

        booru-hs = booru-hs.packages.${pkgs.system}.default;

        # discord = pkgs.discord.override {withMoonlight = true;};
      };
      extraGroups = ["video" "input"];
    };

    hjem.users.rexies.files.".face.icon".source = pkgs.stdenvNoCC.mkDerivation {
      name = "face.jpg";
      nativeBuildInputs = [pkgs.imagemagick];
      src = pkgs.fetchurl {
        url = "https://cdn.donmai.us/original/e9/c3/e9c3dbb346bb4ea181c2ae8680551585.jpg";
        hash = "sha256-0RKzzRxW1mtqHutt+9aKzkC5KijIiVLQqW5IRFI/IWY=";
      };
      dontUnpack = true;
      installPhase = "
          magick $src -crop 640x640+2300+1580 $out
        ";
    };

    hjem.users.rexies.games = {
      enable = true;
      entries = [
        {
          name = "Reverse 1999";
          umu.game_id = "rev199";
          umu.exe = "/home/rexies/Games/Reverse1999en/reverse1999.exe";
        }
      ];
    };
  };
}
