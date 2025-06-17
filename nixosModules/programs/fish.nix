{
  pkgs,
  outputs,
  ...
}: {
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

      # nix stuff
      snwb = "sudo nixos-rebuild boot --flake ~/nixos";
      snwt = "sudo nixos-rebuild test --flake ~/nixos";
      snws = "sudo nixos-rebuild switch --flake ~/nixos";
      nsh = "nix shell nixpkgs#";
      nrn = "nix run nixpkgs#";
      np = "env NIXPKGS_ALLOW_UNFREE=1 nix --impure";

      # git stuff
      ga = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gcp = "git cherry-pick";
      gd = "git diff";
      gds = "git diff --staged";

      # misc
      qsp = "qs  --log-rules 'quickshell.dbus.properties.warning = false' -p ./kurukurubar/";
      lse = "eza --icons --group-directories-first -1";
    };
    shellAliases = {
      ls = "eza --icons --group-directories-first -1";
      snowboot = "sudo nixos-rebuild boot --flake ~/nixos";
      snowfall = "sudo nixos-rebuild switch --flake ~/nixos";
      snowtest = "sudo nixos-rebuild test --flake ~/nixos";
    };

    interactiveShellInit = let
      lsColors = pkgs.runCommandLocal "lscolors" {nativeBuildInputs = [pkgs.vivid];} ''
        vivid generate rose-pine-moon > $out
      '';
      catppucin-theme = [
        "bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8"
        "fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
        "marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
        "selected-bg:#45475a"
        "border:#313244,label:#cdd6f4"
      ];
      fzf-options = builtins.concatStringsSep " " (builtins.map (option: "--color=" + option) catppucin-theme);
    in ''
      set sponge_purge_only_on_exit true
      set fish_greeting
      set fish_cursor_insert line blink
      set -Ux LS_COLORS $(cat ${lsColors})
      set -Ux FZF_DEFAULT_OPTS ${fzf-options}
      fish_vi_key_bindings

      # segsy function to simply open whatever you've typed (in the prompt/) in
      # your $EDITOR so that you can edit there and replace your command line
      # with the edited content
      function open_in_editor -d "opens current commandline in \$EDITOR"
        set current_command $(commandline)
        set tmp_file $(mktemp --suffix=.fish)
        echo $current_command > $tmp_file
        $EDITOR $tmp_file
        commandline $(cat $tmp_file)
        rm $tmp_file
      end

      function fish_user_key_bindings
        bind --mode insert ctrl-o 'open_in_editor'
        bind --mode insert alt-c 'cdi; commandline -f repaint'
        bind ctrl-o 'open_in_editor'
      end

      # hydro (prompt) stuff
      set -g hydro_symbol_start
      set -U hydro_symbol_git_dirty "*"
      set -U fish_prompt_pwd_dir_length 0
      function update_nshell_indicator --on-variable IN_NIX_SHELL
        if test -n "$IN_NIX_SHELL";
          set -g hydro_symbol_start "impure "
        else
          set -g hydro_symbol_start
        end
      end
      update_nshell_indicator
      # inhibits the mode indicator
      function fish_mode_prompt; end;
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    flags = ["--cmd cd"];
  };
  programs.direnv.enableFishIntegration = true;
  programs.starship = {
    enable = false;
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

  environment.systemPackages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.sponge
    pkgs.fishPlugins.hydro
    pkgs.eza
    pkgs.fish-lsp
  ];

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
