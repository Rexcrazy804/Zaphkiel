{
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
}
