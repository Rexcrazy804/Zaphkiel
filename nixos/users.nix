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
        vesktop
        mpv
        cemu
        losslesscut-bin
        transmission_4-qt6
        alacritty
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
        (wrapOBS {
          plugins = with obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        })
      ])
      ++ (with pkgs-stable; [
        # bottles
      ]);
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
