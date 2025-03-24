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
            capslock = "overloadi(esc, overload(alt_motion, esc), 240)";
            esc = "capslock";
          };
          "alt_motion:A" = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };
  };
}
