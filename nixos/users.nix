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

      kdePackages.kdeconnect-kde
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
