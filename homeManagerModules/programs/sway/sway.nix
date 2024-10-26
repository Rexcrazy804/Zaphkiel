{lib, config, pkgs, ...}: {
  options = {
    packages = {
      sway.enable = lib.mkEnableOption "Enable Sway";
    };
  };

  config = lib.mkIf config.packages.sway.enable {
    home.packages = with pkgs; [
      brightnessctl
      pamixer
      grim
      slurp
    ];

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      checkConfig = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        gaps = {
          smartGaps = true;
          smartBorders = "on";
          inner = 10;
          outer = 5;
        };

        window = {
          titlebar = false;
        };

        keybindings = lib.mkOptionDefault {
          # "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Return" = "exec wofi --show drun";
          "${modifier}+Shift+Return" = "exec wofi --show run";
          "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
          # Brightness
        	"XF86MonBrightnessDown" = "exec 'brightnessctl set 1%-'";
        	"XF86MonBrightnessUp" = "exec 'brightnessctl set 1%+'";
          # Volume
        	"XF86AudioRaiseVolume" = "exec 'pamixer --alow-boost -i 5'";
        	"XF86AudioLowerVolume" = "exec 'pamixer --allow-boost -d 5'";
        	"XF86AudioMute" = "exec 'pamixer -t'";
        };

        # support for volume rocker on VMAX keybaord
        keycodebindings = {
        	"115" = "exec 'pamixer -i 1'";
        	"114" = "exec 'pamixer -d 1'";
        };

        input = {
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            drag = "enabled";
            scroll_method = "two_finger";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };

        fonts = {
          names = ["CaskaydiaMono Nerd font"];
          style = "Regular";
          size = 8.0;
        };

        startup = let 
          wall = ../../dots/__yoru_chainsaw_man_drawn_by_banechiii__b55e78c91ee67398c7222a3a1c4286cc.jpg;
        in [
          {command="${pkgs.swaybg}/bin/swaybg -i ${wall} -m fill";}
          # {command="systemctl --user restart waybar"; always = true;}
        ];

        bars = [];
      };
    };
  };
}
