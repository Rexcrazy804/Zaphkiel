{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./common.nix
  ];

  packages = {
    firefox.enable = true;
    alacritty.enable = false;
    discord.enable = true;
    mpv.enable = true;
    sway.enable = false;
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  programs.alacritty.settings.font.size = lib.mkForce 13;

  home.packages = [
    pkgs.rconc
    pkgs.filelight
    pkgs.plasma-panel-colorizer
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["pink"];
    })
  ];
}
