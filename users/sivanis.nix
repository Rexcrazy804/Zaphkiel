{pkgs, config, lib,  ...}: let
  username = "sivanis";
  description = "Sivani SV";
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    # extraGroups = ["networkmanager" "wheel" "multimedia"];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlB7+ziR/1Wcvx/QvVGfI0x/84DjJQzgbUn0/SiGzyj sivani@hercomputer.com"
    ];
  };

  hjem.users.${username} = {
    enable = true;
    user = username;
    directory = config.users.users.${username}.home;
    clobberFiles = lib.mkForce true;

    packages = [
      # nushell dependencies
      pkgs.starship
      pkgs.zoxide
      pkgs.carapace
    ];

    files = let
      matugen = config.programs.matugen;
      matugentheme = matugen.theme.files;
    in {
      # shell
      ".config/nushell/config.nu".source = ./Configs/nushell/config.nu;
      ".config/starship.toml".source = "${matugentheme}/starship.toml";
    };
  };
}
