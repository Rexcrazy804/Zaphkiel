{
  pkgs,
  pkgs-stable,
  ...
}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rexies = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = "Rexiel Scarlet";
    extraGroups = ["networkmanager" "wheel"];
    packages =
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
      ++ (with pkgs-stable; [ # stabilized packages
        # bottles
      ]) ++ [ # overriden packages
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
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
