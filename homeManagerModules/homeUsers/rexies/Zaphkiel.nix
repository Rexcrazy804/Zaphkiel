{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  packages = {
    firefox.enable = true;
    sway.enable = true;
    alacritty.enable = true;
    discord.enable = true;
    obs.enable = true;
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

  home.packages = with pkgs; [
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
    heroic
  ];
}
