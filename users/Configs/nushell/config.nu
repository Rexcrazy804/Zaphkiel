$env.EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

# Shell integrations
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
$env.TRANSIENT_PROMPT_COMMAND = $"(^starship module directory)(^starship module character)"
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
zoxide init nushell --cmd cd | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

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

$env.config = {
  hooks: {
    env_change: {
      PWD: [{|before, after| $env.TRANSIENT_PROMPT_COMMAND = $"(^starship module directory)(^starship module character)" }]
    }
    pre_prompt: [{ ||
      # foot integration
      printf '\e]133;A\e\\'

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}

alias "mchollyjStart" = systemctl start minecraft-server-hollyj.service
alias "mchollyjStatus" = systemctl status minecraft-server-hollyj.service
alias "mchollyjStop" = systemctl stop minecraft-server-hollyj.service
alias "nmpv" = nvidia-offload mpv
alias "servarrStart" = systemctl start jellyfin.service sonarr.service transmission.service
alias "servarrStatus" = systemctl status jellyfin.service sonarr.service transmission.service
alias "servarrStop" = systemctl stop jellyfin.service sonarr.service transmission.service

alias "snowboot" = sudo nixos-rebuild boot --flake ~/nixos
alias "snowfall" = sudo nixos-rebuild switch --flake ~/nixos
alias "snowtest" = sudo nixos-rebuild test --flake ~/nixos
