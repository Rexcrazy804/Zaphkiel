{
  lib,
  pkgs,
  config,
  ...
}: {
  packages = {
    firefox.enable = true;
    alacritty.enable = true;
    mpv.enable = true;
    sway.enable = false;
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  home.packages = with pkgs; [
    btop
  ];

  programs.alacritty.settings.font.size = lib.mkIf config.packages.sway.enable 12;
}
