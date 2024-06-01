{ ... }: {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ../dots/poshconfig.json);
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      snowfall = "sudo nixos-rebuild switch --flake ~/nixos/#Zaphkiel";
    };
    extraConfig = ''
      $env.config.show_banner = false
    '';
  };
}
