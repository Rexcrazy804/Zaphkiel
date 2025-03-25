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
  };
}
