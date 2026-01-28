{self, ...}: let
  inherit (self.lib) mkDotsModule;
  username = "rexies";
in {
  dandelion.users.rexies = {
    pkgs,
    config,
    lib,
    ...
  }: {
    zaphkiel = {
      data.users = [username];
      secrets.rexiesPass = {
        file = self.paths.secrets + /secret1.age;
        owner = username;
      };
    };

    users.users.${username} = {
      description = "Rexiel Scarlet";
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "multimedia"];
      hashedPasswordFile = config.age.secrets.rexiesPass.path;

      # only declare common packages here
      # others: hosts/<hostname>/user-configuration.nix
      # if you declare something here that isn't common to literally every host I
      # will personally show up under your bed whoever and wherever you are
      packages = [
        pkgs.btop
        pkgs.git
        pkgs.bat
        pkgs.delta
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy rexies@Zaphkiel"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn rexies@Raphael"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZvsZTvR5wQedjnuSoz9p7vK7vLxCdfOdRFmbfQ7GUd rexies@Seraphine"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFa4hzkxc5kiBZ4Tr5V4DF1StW9Am9eDzeboIKtGRt89 rexies@Persephone"
      ];
    };

    hjem.users.${username} = {
      enable = true;
      user = username;
      directory = config.users.users.${username}.home;
      clobberFiles = lib.mkForce true;

      impure = {
        enable = true;
        dotsDir = "${self.paths.dots}";
        dotsDirImpure = "/home/rexies/nixos/dots";
        # skips parsing hjem.users.<>.files
        parseAttrs = [
          config.hjem.users.${username}.xdg.config.files
          config.hjem.users.${username}.xdg.state.files
        ];
      };
    };
  };

  # being able to nix freely
  # I have spawned horrors upon this world
  # nix beginners, I am sorry

  dandelion.dots.rexies-cli = mkDotsModule username {
    # terminal
    "git/config" = "/git/config";
    "fish/themes" = {sources, ...}: sources.rosep-fish + "/themes";
    "fish/config.fish" = "/fish/config.fish";
    # NOTE: required bat cache --build before theme can be used
    "bat/config" = "/bat/config";
    "bat/themes" = {sources, ...}: sources.catp-bat + "/themes";
    "shpool/config.toml" = "/shpool/config.toml";
    "yazi/yazi.toml" = "/yazi/yazi.toml";
    "yazi/keymap.toml" = "/yazi/keymap.toml";
    "booru/config.toml" = "/booru/config.toml";
  };

  dandelion.dots.rexies-gui = mkDotsModule username {
    "uwsm/env" = "/uwsm/env";
    "qt6ct/qt6ct.conf" = "/qt6ct/qt6ct.conf";
    "background" = {config, ...}: config.zaphkiel.data.wallpaper;
    "matugen/config.toml" = "/matugen/config.toml";
    "matugen/templates" = "/matugen/templates";
    "fuzzel/fuzzel.ini" = "/fuzzel/fuzzel.ini";
    "foot/foot.ini" = "/foot/foot.ini";
    "foot/rose-pine.ini" = {sources, ...}: sources.rosep-foot + "/rose-pine";
    "hypr/hypridle.conf" = "/hyprland/hypridle.conf";
    "gtk-4.0/settings.ini" = "/gtk/gtk4.ini";
  };

  dandelion.dots.rexies-mango = mkDotsModule username {
    "mango/config.conf" = "/mango/config.conf";
    "mango/autostart.sh" = "/mango/autostart.sh";
    "mango/hardware.conf" = d: d.dotsDir + "/mango/${d.lib.toLower d.config.networking.hostName}.conf";
  };

  dandelion.dots.rexies-hyprland = mkDotsModule username {
    "hypr/hyprland.conf" = "/hyprland/hyprland.conf";
  };
}
