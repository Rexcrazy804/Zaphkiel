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
    alacritty.enable = true;
    mpv.enable = true;
    sway.enable = true;
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  # was required for mpv on xfce
  # programs.mpv.config.gpu-context = lib.mkForce "x11egl";

  # default is 11.72 which is kinda blurry and not so visible in sway
  # [atleast for Raphael's display]
  programs.alacritty.settings.font.size = lib.mkIf config.packages.sway.enable 12;

  home.packages = with pkgs; [
    qutebrowser
  ];

  age.secrets.wallpaper_alt = {
    file = ../../../secrets/media_kok_exquisite.age;
    name = "wallpaper_alt.png";
  };

  wayland.windowManager.sway.config.output."*".bg = lib.mkForce "${config.age.secrets.wallpaper_alt.path} fill";
}
