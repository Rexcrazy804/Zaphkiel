{lib, config, ...}: {
  config = lib.mkIf config.packages.sway.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        color = "303030";
        font-size = 24;
        indicator-idle-visible = true;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };
  };
}
