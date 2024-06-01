{pkgs, pkgs-stable, ...}: {
  home.username = "rexies";
  home.homeDirectory = "/home/rexies";

  # Packages that should be installed to the user profile.
  home.packages =
    (with pkgs; [
      #general
      firefox
      mpv
      losslesscut-bin
      transmission_4-qt6
      alacritty

      # emulators
      cemu
      ryujinx

      # wine
      bottles
      wineWowPackages.staging

      # terminal
      zoxide
      oh-my-posh
      carapace

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

      # obs specific configuration
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

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Rexiel Scarlet";
    userEmail = "37258415+Rexcrazy804@users.noreply.github.com";
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  # programs.alacritty = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     env.TERM = "xterm-256color";
  #     font = {
  #       size = 12;
  #       draw_bold_text_with_bright_colors = true;
  #     };
  #     scrolling.multiplier = 5;
  #     selection.save_to_clipboard = true;
  #   };
  # };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
