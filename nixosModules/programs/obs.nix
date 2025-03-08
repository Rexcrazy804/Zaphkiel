{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.obs-studio.enable = lib.mkEnableOption "Enable OBS studio";
  };

  config = lib.mkIf config.progModule.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = let
        obsplgns = pkgs.obs-studio-plugins;
      in [
        obsplgns.wlrobs
        obsplgns.obs-backgroundremoval
        obsplgns.obs-pipewire-audio-capture
        obsplgns.obs-vkcapture
      ];
    };
  };
}
