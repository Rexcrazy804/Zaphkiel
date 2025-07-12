{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zaphkiel.programs.obs-studio.enable = lib.mkEnableOption "obs-studio";
  config = lib.mkIf config.zaphkiel.programs.anime-games.enable {
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
