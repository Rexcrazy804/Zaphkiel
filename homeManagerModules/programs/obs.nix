{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packages = {
      obs.enable = lib.mkEnableOption "Enable obs";
    };
  };

  config = lib.mkIf config.packages.obs.enable {
    home.packages = with pkgs; [
      (wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      })
    ];
  };
}
