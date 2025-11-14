# why is this a nix file?
# well writing this in .conf looks ugly so yeah .w.
{writeText}: let
  shaderFolder = ./shaders;
in
  writeText "input.conf" ''
    CTRL+1 no-osd change-list glsl-shaders set "${builtins.concatStringsSep ":" [
      "${shaderFolder}/Anime4K_AutoDownscalePre_x2.glsl"
      "${shaderFolder}/Anime4K_AutoDownscalePre_x4.glsl"

      "${shaderFolder}/Anime4K_Clamp_Highlights.glsl"

      "${shaderFolder}/Anime4K_Restore_CNN_M.glsl"
      "${shaderFolder}/Anime4K_Restore_CNN_VL.glsl"

      "${shaderFolder}/Anime4K_Upscale_CNN_x2_M.glsl"
      "${shaderFolder}/Anime4K_Upscale_CNN_x2_VL.glsl"
    ]}"; show-text "Anime4K: Mode A+A (HQ)"

    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"
  ''
# CTRL+1 no-osd change-list glsl-shaders set "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"

