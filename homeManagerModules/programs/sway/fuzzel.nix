{lib, config, ...}: {
  config = let 
    cfg = config.wayland.windowManager.sway.config;
  in lib.mkIf config.packages.sway.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "CaskaydiaMono Nerd font=size:10";
          dpi-aware = "auto";
          terminal = cfg.terminal;
          icons-enabled = false;
          lines = 5;
          horizontal-pad = 10;
          prompt = "";
        };

        border = {
          radius = 0;
          width = 0;
        };

        colors = let
          hotpink = "fc0521ff";
        in {
          background = "30303088";
          prompt = "fc0521ce";
          input = "hotpink";
          match = hotpink;
          selection-match = hotpink;
          text = "aaaaaace";
        };
      };
    };
  };
}
