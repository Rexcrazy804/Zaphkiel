{
  pkgs,
  inputs,
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
  in
    lib.mkIf cfg.enable (lib.mkMerge [
      (import ./moduleconf.nix pkgs)
      {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
    ]);
}
