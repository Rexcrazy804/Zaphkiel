{lib, config, pkgs, ...}: let
in {
  options = {
    packages = {
      sway.enable = lib.mkEnableOption "Enable Sway";
    };
  };

  config = lib.mkIf config.packages.hyprland.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        color = "303030";
        font-size = 24;
        indicator-idle-visible = true;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };

    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
        { event = "lock"; command = "lock"; }
      ];
    };

    services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        notification-inline-replies = true;
        notification-icon-size = 32;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
      };

      style = ''
        .notification-row {
          outline: none;
        }

        .notification-row:focus,
        .notification-row:hover {
          background: @noti-bg-focus;
        }

        .notification {
          border-radius: 12px;
          margin: 6px 12px;
          box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
            0 2px 6px 2px rgba(0, 0, 0, 0.3);
          padding: 0;
        }
      '';
    };

    services.swayosd = {
      enable = true;
      # stylePath = null;
    };

    wayland.windowManager.sway = {
      checkConfig = true;
      config = {
        modifer = "Mod4";
        terminal = "alacritty";
        gaps.smartGaps = true;

        keybinds = let
          cfg = config.wayland.windowManager.sway.config;
          modifier = cfg.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${cfg.terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
        };
      };
    };
  };
}
