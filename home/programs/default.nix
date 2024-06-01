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

  home.packages =
    (with pkgs; [
      #general
      firefox
      losslesscut-bin
      transmission_4-qt6

      # emulators
      cemu
      ryujinx

      # wine
      bottles
      wineWowPackages.staging

      # nvim
      nerdfonts
      lua-language-server
      nixd
      ripgrep
      zoxide
      wl-clipboard

      # archives
      p7zip
      unrar

      kdePackages.kdeconnect-kde
    ])
    ++ (with pkgs-stable; [
      # stabilized packages
      # bottles
    ])
    ++ [
      # overriden packages
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })

      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      })

      (pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["red"];
      })
    ];
}
