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
    mpv.enable = false;
    sway.enable = false;
  };

  packageGroup = {
    wine.enable = false;
    multimedia.enable = false;
  };
}
