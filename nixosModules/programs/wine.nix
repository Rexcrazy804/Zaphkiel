{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf genAttrs;
  cfg = config.zaphkiel.programs.wine;
in {
  # primary reference https://gitlab.com/fazzi/nixohess/-/blob/main/modules/gaming/default.nix
  options.zaphkiel.programs.wine = {
    enable = mkEnableOption "wine";
    ntsync.enable = mkEnableOption "ntsync kernel module";
    wayland.enable = mkEnableOption "wine wayland";
    ge-proton.enable = mkEnableOption "proton ge link";
  };

  config = mkIf cfg.enable {
    users.users = genAttrs config.zaphkiel.data.users (_user: {
      extraGroups = ["video" "input"];
    });

    boot.kernelModules = mkIf cfg.ntsync.enable ["ntsync"];
    services.udev.extraRules = mkIf cfg.ntsync.enable ''
      KERNEL=="ntsync", MODE="0644"
    '';

    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = mkIf cfg.wayland.enable 1;
      "PROTON_USE_WOW64" = 1;
      "PROTONPATH" = mkIf cfg.ge-proton.enable pkgs.proton-ge-bin.steamcompattool;
    };
  };
}
