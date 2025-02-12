{
  pkgs,
  lib,
}: let
in
  /*
  nu
  */
  ''
    load-env {
        "EDITOR": "/run/current-system/sw/bin/nvim"
    }

    # nushell configuration
    $env.config.show_banner = false
    $env.config.edit_mode = "vi"
    $env.PROMPT_INDICATOR_VI_INSERT = ""
    $env.PROMPT_INDICATOR_VI_NORMAL = ""

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

    source ~/.cache/zoxide/init.nu
    source ~/.cache/oh-my-posh/init.nu
    source ~/.cache/carapace/init.nu

    $env.config = ($env.config? | default {})
    $env.config.hooks = ($env.config.hooks? | default {})
    $env.config.hooks.pre_prompt = (
        $env.config.hooks.pre_prompt?
        | default []
        | append {||
            ${lib.getExe pkgs.direnv} export json
            | from json --strict
            | default {}
            | items {|key, value|
                let value = do (
                    $env.ENV_CONVERSIONS?
                    | default {}
                    | get -i $key
                    | get -i from_string
                    | default {|x| $x}
                ) $value
                return [ $key $value ]
            }
            | into record
            | load-env
        }
    )

    alias "mchollyjStart" = systemctl start minecraft-server-hollyj.service
    alias "mchollyjStatus" = systemctl status minecraft-server-hollyj.service
    alias "mchollyjStop" = systemctl stop minecraft-server-hollyj.service
    alias "nmpv" = nvidia-offload mpv
    alias "servarrStart" = systemctl start jellyfin.service sonarr.service transmission.service
    alias "servarrStatus" = systemctl status jellyfin.service sonarr.service transmission.service
    alias "servarrStop" = systemctl stop jellyfin.service sonarr.service transmission.service

    alias "snowboot" = sudo nixos-rebuild boot --flake ~/nixos/#Seraphine
    alias "snowfall" = sudo nixos-rebuild switch --flake ~/nixos/#Seraphine
    alias "snowtest" = sudo nixos-rebuild test --flake ~/nixos/#Seraphine
  ''
