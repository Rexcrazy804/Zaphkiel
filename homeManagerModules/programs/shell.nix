{hostname, ...}: {
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
    stdlib = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      snowfall = "sudo nixos-rebuild switch --flake ~/nixos/#${hostname}";
      snowtest = "sudo nixos-rebuild test --flake ~/nixos/#${hostname}";
      snowboot = "sudo nixos-rebuild boot --flake ~/nixos/#${hostname}";

      # servarr
      servarrStart = "systemctl start jellyfin.service sonarr.service transmission.service";
      servarrStop = "systemctl stop jellyfin.service sonarr.service transmission.service";
      servarrStatus = "systemctl status jellyfin.service sonarr.service transmission.service";

      # minecraft-nix
      mchollyjStart = "systemctl start minecraft-server-hollyj.service";
      mchollyjStop = "systemctl stop minecraft-server-hollyj.service";
      mchollyjStatus = "systemctl status minecraft-server-hollyj.service";

      nmpv = "nvidia-offload mpv";
    };
    environmentVariables = {
      EDITOR = "/run/current-system/sw/bin/nvim";
    };

    extraConfig = let
      nuscripts = ../dots/nuscripts;
    in
      /*
      nu
      */
      ''
        # nushell configuration
        $env.config.show_banner = false
        $env.config.edit_mode = "vi"
        $env.PROMPT_INDICATOR_VI_INSERT = ""
        $env.PROMPT_INDICATOR_VI_NORMAL = ""

        # sourcing nushell scripts
        source ${nuscripts}/nix.nu
        # source ${nuscripts}/error_hook.nu

        # custom definitions
        def envinit [] { 'use flake' | save .envrc }
        def batstat [] {
          cat /sys/class/power_supply/BAT0/uevent
          | split row "\n"
          | each { |it|
            let data = $it | split row '=';
            { entry: $data.0 value: $data.1}
          }
        }
        def freemem [] {
          free -h
          | detect columns
          | insert 1.device "swap"
          | insert 0.device "mem"
          | move device --before total
        }

        # helping out the homies
        def snowupdate [] {
          let update_file = '~/nixos/updating';
          mut should_update = $update_file | path exists;

          if not ($should_update) {
            let original = open ~/nixos/flake.lock | str join
            nix flake update --flake ~/nixos
            let new = open ~/nixos/flake.lock | str join
            if $original != $new {
              $should_update = true;
              touch ~/nixos/updating;
            }
          }

          if $should_update {
            print "Updates found :)\nRunning snowfall..."
            do { 
              ^sudo nixos-rebuild switch --flake ~/nixos/#${hostname} 
            }

            if ($env.LAST_EXIT_CODE == 0) {
              print "Update Complete :D"
            } else {
              print "Update Failed :<"
            }

            rm ~/nixos/updating
          } else {
            print "Nothing to update :<"
          }
        }
      '';
  };
}
