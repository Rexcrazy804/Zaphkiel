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
    firefox.enable = false;
    alacritty.enable = false;
    discord.enable = false;
    mpv.enable = true;
    sway.enable = false;
  };

  packageGroup = {
    wine.enable = false;
    multimedia.enable = false;
  };

  programs.alacritty.settings.font.size = lib.mkForce 13;

  # home.packages = [
  #   pkgs.rconc
  #   pkgs.filelight
  #   pkgs.plasma-panel-colorizer
  #   (pkgs.catppuccin-kde.override {
  #     flavour = ["mocha"];
  #     accents = ["pink"];
  #   })
  # ];
}
