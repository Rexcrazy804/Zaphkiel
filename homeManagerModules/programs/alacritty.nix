{
  lib,
  config,
  ...
}: {
  options = {
    packages.alacritty.enable = lib.mkEnableOption "Enable Alacritty";
  };

  config = lib.mkIf config.packages.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          opacity = 0.87;
          startup_mode = "Maximized";
          padding = {
            x = 5;
            y = 10;
          };
          # enabling sway will set this
          # size = 12;
        };

        env = {
          TERM = "xterm-256color";
        };

        font = {
          normal = {
            family = "CaskaydiaMono Nerd font";
            style = "Regular";
          };
        };

        cursor = {
          style = {
            shape = "Block";
            blinking = "On";
          };
        };

        mouse = {
          hide_when_typing = true;
        };
      };
    };
  };
}
