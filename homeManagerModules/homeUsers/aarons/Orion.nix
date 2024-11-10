{pkgs, ...}: {
  packages = {
    alacritty.enable = true;
    mangohud.enable = true;
    mpv = {
      enable = true;
      anime4k.enable = true;
    };
  };

  packageGroup = {
    wine.enable = true;
    multimedia.enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  home.packages = with pkgs; [
    kdePackages.filelight
    heroic
    discord
    opera
    brave
    kodi-wayland
  ];
}
