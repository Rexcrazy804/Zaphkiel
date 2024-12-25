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
          let original = open ~/nixos/flake.lock | str join
          nix flake update --flake ~/nixos
          let new = open ~/nixos/flake.lock | str join
          if $original != $new {
            # Right now if you ctrl + c out of snowfall you will not apply the
            # updates but the next time you run snowupdate it will say no updates
            # so if you ctrl + c out of snowfall when running snowupdate just
            # snowfall instead
            print "Updates found :)\nRunning snowfall..."
            # snowfall [the actuall command the alias runs]
            sudo nixos-rebuild switch --flake ~/nixos/#${hostname}
            print "Update Complete :D"
          } else {
            print "Nothing to update :<"
          }
        }
      '';
  };
}
