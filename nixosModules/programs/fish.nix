{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      # old stuff not sure if I'll ever use em
      # alias "mchollyjStart" = systemctl start minecraft-server-hollyj.service
      # alias "mchollyjStatus" = systemctl status minecraft-server-hollyj.service
      # alias "mchollyjStop" = systemctl stop minecraft-server-hollyj.service
      # alias "nmpv" = nvidia-offload mpv
      # alias "servarrStart" = systemctl start jellyfin.service sonarr.service transmission.service
      # alias "servarrStatus" = systemctl status jellyfin.service sonarr.service transmission.service
      # alias "servarrStop" = systemctl stop jellyfin.service sonarr.service transmission.service

      snowboot = "sudo nixos-rebuild boot --flake ~/nixos";
      snowfall = "sudo nixos-rebuild switch --flake ~/nixos";
      snowtest = "sudo nixos-rebuild test --flake ~/nixos";
    };
    interactiveShellInit = ''
      set sponge_purge_only_on_exit true
      set fish_greeting
      set fish_cursor_insert block blink

      fish_vi_key_bindings

      # segsy function to simply open whatever you've typed (in the prompt/) in
      # your $EDITOR so that you can edit there and replace your command line
      # with the edited content
      function open_in_editor
        set current_command $(commandline)
        set tmp_file $(mktemp)
        echo $current_command > $tmp_file
        $EDITOR $tmp_file
        commandline $(cat $tmp_file)
        rm $tmp_file
      end

      function fish_user_key_bindings
        bind --mode insert ctrl-o open_in_editor
      end
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    flags = ["--cmd cd"];
  };
  programs.direnv.enableFishIntegration = true;
  programs.starship = {
    enable = true;
    transientPrompt.enable = true;
    # I don't know why they thought not including starship in environment.systemPackages was
    # a genius idea
    transientPrompt.left = ''
      ${pkgs.starship}/bin/starship module directory
      ${pkgs.starship}/bin/starship module character
    '';
  };
  programs.command-not-found.enable = false;
  programs.fzf.keybindings = true;

  environment.systemPackages = [pkgs.fishPlugins.done pkgs.fishPlugins.sponge];

  programs.bash = {
    # adapted from nixos wiki for using bash as login shell and then launching fish
    # IMPORTANT: modified to improve direnv support by using fish if IN_NIX_SHELL var is set
    # Note works with nix shell but not with nix develop
    interactiveShellInit = ''
      if [[ ($(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" || -n ''${IN_NIX_SHELL}) && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
