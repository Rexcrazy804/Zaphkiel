{
  pkgs,
  config,
  sources,
  lib,
  ...
}: let
  username = "rexies";
  description = "Rexiel Scarlet";
  cleanDots = let
    inherit (lib.fileset) unions toSource;
    root = ./dots;
  in
    toSource {
      inherit root;
      fileset = unions [
        (root + /git/config)
        (root + /fish/config.fish)
        (root + /bat/config)
        (root + /foot/foot.ini)
        (root + /fuzzel/fuzzel.ini)
        (root + /uwsm/env)
        (root + /hyprland/hypridle.conf)
        (root + /hyprland/hyprland.conf)
        (root + /yazi/yazi.toml)
        (root + /yazi/keymap.toml)
        (root + /matugen)
      ];
    };
in {
  zaphkiel = {
    data.users = [username];
    programs.matugen.enable = true;
    secrets.rexiesPass = {
      file = ../secrets/secret1.age;
      owner = username;
    };
  };

  users.users.${username} = {
    inherit description;

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

  # hjem
  hjem.users.${username} = {
    enable = true;
    user = username;
    directory = config.users.users.${username}.home;
    clobberFiles = lib.mkForce true;

    impure = {
      enable = true;
      dotsDir = "${cleanDots}";
      dotsDirImpure = "/home/rexies/nixos/users/dots";
      # skips parsing hjem.users.<>.files
      parseAttrs = [config.hjem.users.${username}.xdg.config.files];
    };

    files.".face.icon".source = let
      image = config.programs.booru-flake.images."8726475";
    in
      pkgs.runCommandWith {
        name = "croped-${image.name}";
        derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
      } ''
        magick ${image} -crop 500x500+398+100 - >  $out
      '';

    xdg.config.files = let
      dots = config.hjem.users.${username}.impure.dotsDir;
    in {
      # git
      "git/config".source = dots + "/git/config";

      # shell
      "fish/themes".source = sources.rosep-fish + "/themes";
      "fish/config.fish".source = dots + "/fish/config.fish";
      # bat
      "bat/config".source = dots + "/bat/config";
      # NOTE: required bat cache --build before theme can be used
      "bat/themes".source = sources.catp-bat + "/themes";

      # foot terminal
      "foot/foot.ini".source = dots + "/foot/foot.ini";
      "foot/rose-pine.ini".source = sources.rosep-foot + "/rose-pine";

      # hyprland
      "uwsm/env".source = dots + "/uwsm/env";
      "hypr/hypridle.conf".source = dots + "/hyprland/hypridle.conf";
      "hypr/hyprland.conf".source = dots + "/hyprland/hyprland.conf";
      "yazi/yazi.toml".source = dots + "/yazi/yazi.toml";
      "yazi/keymap.toml".source = dots + "/yazi/keymap.toml";
      "fuzzel/fuzzel.ini".source = dots + "/fuzzel/fuzzel.ini";
      "background".source = config.zaphkiel.data.wallpaper;
      "matugen/config.toml".source = dots + "/matugen/config.toml";
      "matugen/templates".source = dots + "/matugen/templates";
    };
  };
}
