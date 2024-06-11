{
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
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
      $env.config.edit_mode = vi
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_INDICATOR_VI_NORMAL = ""

    '';
    environmentVariables = {
      EDITOR = "nvim";
    };
  };
}
