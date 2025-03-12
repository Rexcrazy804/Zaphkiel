{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland";
    };
  };

  config = let 
    cfg = config.progModule.hyprland;
  in lib.mkIf cfg.enable (import ./moduleconf.nix pkgs);
}
