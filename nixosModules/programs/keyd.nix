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
          };
          "alt_motion:A" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            ";" = "backspace";
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
