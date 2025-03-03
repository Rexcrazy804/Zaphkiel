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

def start_gpurecording [] {
  notify-send -t 600 "recording started";
  gpu-screen-recorder -w eDP-1 -f 60 -a default_output -o $"($env.HOME)/Videos/recording-(^date +%d%h%m_%H%M%S).mp4";
  notify-send -t 600 "recording stoped"
}

def stop_gpurecording [] {
  ps
  | where name =~ gpu-screen-reco
  | kill -s 2 $in.0.pid
}
def cowask [question] {
  cowsay $"($question)? \n (if (random bool) { 'yes lol' } else {'no fuck you' })"
}

source ~/.cache/zoxide/init.nu
source ~/.cache/oh-my-posh/init.nu
source ~/.cache/carapace/init.nu

$env.config = {
  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

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

let host = cat /etc/hostname;
alias "snowboot" = sudo nixos-rebuild boot --flake ~/nixos/#($host)
alias "snowfall" = sudo nixos-rebuild switch --flake ~/nixos/#($host)
alias "snowtest" = sudo nixos-rebuild test --flake ~/nixos/#($host)
