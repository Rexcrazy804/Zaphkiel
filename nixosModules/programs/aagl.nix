{
  sources,
  lib,
  config,
  ...
}: {
  options = {
    progModule.anime-games.enable = lib.mkEnableOption "Enable Anime Games";
  };

  config = lib.mkIf config.progModule.anime-games.enable {
    nix.settings.extra-substituters = ["https://ezkea.cachix.org"];
    nix.settings.extra-trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    programs = {
      anime-game-launcher.enable = lib.mkDefault false;
      honkers-railway-launcher.enable = lib.mkDefault true;
      sleepy-launcher.enable = lib.mkDefault true;
    };
  };
}
