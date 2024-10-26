{lib, config, ...}: {
  config = let 
    cfg = config.wayland.windowManager.sway.config;
  in lib.mkIf config.packages.sway.enable {
    programs.wofi = {
      enable = true;
      settings = {
        location = "bottom-right";
        allow_markup = true;
        width = 250;
        allow_images = false;
        hide_scroll = true;
        no_actions = false;
        term = cfg.terminal;
      };

      style = /*css*/ ''
        * {
          font-family: monospace;
        }

        window {
            background-color: #3B4252;
        }

        #input {
            margin: 5px;
            border-radius: 0px;
            border: none;
            background-color: #3B4252;
            color: white;
        }

        #inner-box {
            background-color: #383C4A;
        }

        #outer-box {
            margin: 2px;
            padding: 10px;
            background-color: #383C4A;
        }

        #scroll {
            margin: 5px;
        }

        #text {
            padding: 4px;
            color: white;
        }

        #entry:nth-child(even){
            background-color: #404552;
        }

        #entry:selected {
            background-color: #4C566A;
        }

        #text:selected {
            background: transparent;
        }
      '';
    };
  };
}
