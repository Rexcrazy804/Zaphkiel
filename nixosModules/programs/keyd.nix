{
  lib,
  config,
  ...
}: {
  options = {
    progModule.keyd.enable = lib.mkEnableOption "Enable keyd daemon";
  };

  config = lib.mkIf config.progModule.keyd.enable {
    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "overload(alt_motion, esc)";
            esc = "capslock";
            compose = "overload(menu_layer, compose)";
          };
          "alt_motion:A" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            ";" = "backspace";
          };
          "menu_layer" = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            q = "4";
            w = "5";
            e = "6";
            a = "7";
            s = "8";
            d = "9";
            c = "0";
          };
        };
      };
    };

    # borrowed from the nixOS wiki
    # Optional, but makes sure that when you type the make palm rejection work with keyd
    # https://github.com/rvaiya/keyd/issues/723
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
