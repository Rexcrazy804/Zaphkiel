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
    mpv.enable = true;
  };

  home.packages = with pkgs; [
    firefox
  ];
}
