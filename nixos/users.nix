{pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rexies = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = "Rexiel Scarlet";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #general
      firefox
      vscode
      vesktop
      mpv
      cemu
      losslesscut-bin
      transmission_4-qt6
      alacritty

      # wine
      wineWowPackages.staging

      # terminal
      zoxide
      oh-my-posh

      # nvim
      nerdfonts
      lua-language-server
      nixd
      ripgrep
      zoxide
      wl-clipboard

      kdePackages.kdeconnect-kde
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
