{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  packages = {
    alacritty.enable = true;
    mangohud.enable = true;
    mpv = {
      enable = true;
      anime4k.enable = true;
    };
  };

  home.packages = with pkgs; [];
}
