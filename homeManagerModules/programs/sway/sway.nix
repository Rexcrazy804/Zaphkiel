{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    packages = {
      sway.enable = lib.mkEnableOption "Enable Sway";
    };
  };

  config = lib.mkIf config.packages.sway.enable {
    home.packages = with pkgs; [
      brightnessctl
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
          inner = 6;
          outer = 2;
        };

        window = {
          titlebar = false;
        };

        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          # "${modifier}+d" = "exec fuzzel";
          "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
          # Brightness
          "XF86MonBrightnessDown" = "exec 'brightnessctl set 1%-'";
          "XF86MonBrightnessUp" = "exec 'brightnessctl set 1%+'";
          # Volume
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
        };

        # support for volume rocker on VMAX keybaord
        keycodebindings = {
          "115" = "exec wpctl set-volume @DEFAULT_SINK@ 1%+";
          "114" = "exec wpctl set-volume @DEFAULT_SINK@ 1%-";
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

        # seat seat0 xcursor_theme $cursor_theme $cursor_size
        seat = {
          "seat0" = {
            xcursor_theme = "Adwaita 24";
          };
        };

        startup = let
          wall = ../../dots/__yoru_chainsaw_man_drawn_by_banechiii__b55e78c91ee67398c7222a3a1c4286cc.jpg;
        in [
          {command = "${pkgs.swaybg}/bin/swaybg -i ${wall} -m fill";}
          # {command="wlsunset";}
          # {command="systemctl --user restart waybar"; always = true;}
        ];

        bars = [];
      };
    };
  };
}
