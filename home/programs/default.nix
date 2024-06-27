{pkgs, ...}: {
  imports = [
    ./alacritty.nix
    ./generic.nix
    ./shell.nix
    ./mpv.nix
  ];

  home.packages = builtins.attrValues {
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };

    obs = pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    };

    catppuccin-kde = pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    };

    wine = pkgs.wineWowPackages.stable;

    inherit
      (pkgs.kdePackages)
      kdeconnect-kde
      kdenlive
      filelight
      ;

    inherit
      (pkgs)
      firefox
      losslesscut-bin
      transmission_4-qt6
      zenith-nvidia
      #general
      
      cemu
      ryujinx
      # emulators
      
      winetricks
      bottles
      #wine
      
      wl-clipboard
      ripgrep
      # nvim
      
      p7zip
      unrar
      # archives
      
      ;
  };
}
