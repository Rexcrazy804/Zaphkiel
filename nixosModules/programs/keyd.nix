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
        settings.main = {
          capslock = "overloadi(esc, overload(alt, esc), 200)";
          esc = "capslock";
        };
      };
    };
  };
}
