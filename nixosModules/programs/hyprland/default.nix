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
      {
        environment.systemPackages = [
          (inputs.quickshell.packages.${pkgs.system}.default.override {
            withJemalloc = true;
            withQtSvg = true;
            withWayland = true;
            withX11 = false;
            withPipewire = true;
            withPam = true;
            withHyprland = true;
            withI3 = false;
          })
        ];
      }
    ]);
}
