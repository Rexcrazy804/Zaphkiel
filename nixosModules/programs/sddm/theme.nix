{
  fetchurl,
  runCommandWith,
  ffmpeg,
}: let
  zero-bg = fetchurl {
    url = "https://www.desktophut.com/files/kV1sBGwNvy-Wallpaperghgh2Prob4.mp4";
    hash = "sha256-VkOAkmFrK9L00+CeYR7BKyij/R1b/WhWuYf0nWjsIkM=";
  };

  zero-thumb =
    runCommandWith {
      name = "thumbnail.png";
      derivationArgs.nativeBuildInputs = [ffmpeg];
    } ''
      ffmpeg -i ${zero-bg} -vf "select=eq(n\,34)" -vframes 1 $out
    '';
in {
  theme = "rei";
  extraBackgrounds = [zero-bg zero-thumb];
  theme-overrides = {
    "LoginScreen.LoginArea.Avatar" = {
      shape = "circle";
      active-border-size = 0;
      inactive-border-size = 0;
    };
    "LoginScreen" = {
      background = "${zero-bg.name}";
    };
    "LockScreen" = {
      background = "${zero-bg.name}";
    };
    "General" = {
      animated-background-placeholder = "${zero-thumb.name}";
    };
  };
}
