{
  dandelion.modules.obs-studio = {pkgs, ...}: {
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
