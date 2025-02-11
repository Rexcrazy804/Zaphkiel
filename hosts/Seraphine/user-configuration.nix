{pkgs, ...}: {
  users.users."rexies".packages = builtins.attrValues {
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

    inherit (pkgs.wineWowPackages) stable;
    inherit
      (pkgs)
      bottles
      winetricks
      rconc
      filelight
      plasma-panel-colorizer
      ;

    catppucin-kde = pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["pink"];
    };
  };
}
