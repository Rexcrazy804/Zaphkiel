{pkgs, ...}: let
  generic = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.rconc
    pkgs.filelight
    pkgs.plasma-panel-colorizer
  ];
  special = builtins.attrValues {
    alacritty = pkgs.wrappedPkgs.alacritty.override {
      extra-config = {
        font.size = 13.0;
      };
    };

    mpv = pkgs.wrappedPkgs.mpv;

    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };
    catppucin-kde = pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["pink"];
    };
  };
in {
  users.users."rexies".packages = special ++ generic;
}
