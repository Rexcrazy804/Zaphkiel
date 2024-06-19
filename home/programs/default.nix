{
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./generic.nix
    ./shell.nix
  ];

  home.packages = let 
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };

    obs = pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    catppuccin-kde = pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    };

    unstable = with pkgs; [
        #general
        firefox
        losslesscut-bin
        transmission_4-qt6
        amberol

        # emulators
        cemu
        ryujinx

        # wine
        bottles
        wineWowPackages.staging

        # nvim
        wl-clipboard
        ripgrep

        # archives
        p7zip
        unrar

        kdePackages.kdeconnect-kde
      ];

    stable = with pkgs-stable; [];

    overriden = [ discord obs catppuccin-kde ];
  in unstable ++ stable ++ overriden;
}
