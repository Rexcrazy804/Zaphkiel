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
    alacritty.enable = true;
    discord.enable = true;
    mpv.enable = true;
    sway.enable = false;
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  programs.alacritty.settings.font.size = lib.mkIf config.packages.sway.enable 12;
}
