{
  lib,
  config,
  ...
}: {
  options = {
    packages.mpv = {
      enable = lib.mkEnableOption "Enable mpv";
      anime4k.enable = lib.mkEnableOption "Enable Anime4k Upscaling";
    };
  };

  config = let
    cfg = config.packages.mpv;
  in
    lib.mkIf cfg.enable {
      programs.mpv = let
        shaderFolder = ../dots/mpv/shaders;
      in {
        enable = true;

        config = {
          hwdec = "auto-safe";
          vo = "gpu";
          profile = "gpu-hq";
          gpu-context = "wayland";
          geometry = "75%x75%";
          screenshot-template = "'%F - [%P] (%#01n)'";
        };

        bindings = lib.mkIf cfg.anime4k.enable {
          # shaders BABY [Anime4k Upscaller]
          "CTRL+1" =
            "no-osd change-list glsl-shaders set \""
            + builtins.concatStringsSep ":" [
              "${shaderFolder}/Anime4K_AutoDownscalePre_x2.glsl"
              "${shaderFolder}/Anime4K_AutoDownscalePre_x4.glsl"

              "${shaderFolder}/Anime4K_Clamp_Highlights.glsl"

              "${shaderFolder}/Anime4K_Restore_CNN_M.glsl"
              "${shaderFolder}/Anime4K_Restore_CNN_VL.glsl"

              "${shaderFolder}/Anime4K_Upscale_CNN_x2_M.glsl"
              "${shaderFolder}/Anime4K_Upscale_CNN_x2_VL.glsl"
            ]
            + "\"; show-text \"Anime4K: Mode A+A (HQ)\"";

          "CTRL+0" = "no-osd change-list glsl-shaders clr \"\"; show-text \"GLSL shaders cleared\"";
        };
      };
    };
}
