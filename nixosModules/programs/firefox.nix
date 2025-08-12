{
  lib,
  config,
  pkgs,
  ...
}: {
  options.zaphkiel.programs.firefox.enable = lib.mkEnableOption "firefox";
  config = lib.mkIf config.zaphkiel.programs.firefox.enable {
    programs.firefox = {
      package = pkgs.librewolf;
      enable = true;
    };
  };
}
