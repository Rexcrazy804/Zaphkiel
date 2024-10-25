{lib, config, pkgs, ...}: {
  options = {
    packages = {
      sway.enable = lib.mkEnableOption "Enable Sway";
    };
  };

  config = lib.mkIf config.packages.sway.enable {
    services.swayosd = {
      enable = true;
      # stylePath = null;
    };

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      checkConfig = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        gaps = {
          smartGaps = true;
          smartBorders = "on";
          inner = 10;
          outer = 5;
        };

        keybindings = let
          cfg = config.wayland.windowManager.sway.config;
          modifier = cfg.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${cfg.terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
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
          {command="${pkgs.swaybg}/bin/swaybg -i ${wall} -m fill"; always = true;}
          {command="systemctl --user restart waybar"; always = true;}
        ];

        bars = [];
      };
    };
  };
}
