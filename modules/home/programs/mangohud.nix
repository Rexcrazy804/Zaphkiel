{lib, config, ... }: {
  options = {
    packages.mangohud.enable = lib.mkEnableOption "Enable mangohud";
  };

  config = lib.mkIf config.packages.mangohud.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        preset = 2;
        position = "bottom-left";
        no_display = true;
      };
    };
  };
}
