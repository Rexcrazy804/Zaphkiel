# requires utils/zaphkiel-data.nix
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (inputs.self) paths;

  username = "rexies";
in {
  zaphkiel = {
    data.users = [username];
    secrets.rexiesPass = {
      file = paths.secrets + /secret1.age;
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
      dotsDir = "${paths.dots}";
      dotsDirImpure = "/home/rexies/nixos/dots";
      # skips parsing hjem.users.<>.files
      parseAttrs = [
        config.hjem.users.${username}.xdg.config.files
        config.hjem.users.${username}.xdg.state.files
      ];
    };
  };
}
