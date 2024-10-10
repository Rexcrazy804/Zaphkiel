{lib, ...}: {
  imports = [
    ./common.nix
  ];

  packages = {
    alacritty.enable = true;
    mpv.enable = true;
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  programs.mpv.config.gpu-context = lib.mkForce "x11egl";
}
