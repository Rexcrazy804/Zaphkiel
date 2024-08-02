{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
  ];

  options = {
    progModule.anime-games = {
      enable = lib.mkEnableOption "Enable certain Anime Games";
      cache.enable = lib.mkEnableOption "Enable aagl binary cache";
      impact.enable = lib.mkEnableOption "Enable Anime game";
      rail.enable = lib.mkEnableOption "Enable Honkers Railway";
      zone.enable = lib.mkEnableOption "Enable Sleepy game";
    };
  };

  config = let
    cfg = config.progModule.anime-games;
  in
    lib.mkIf cfg.enable {
      nix.settings = lib.mkIf cfg.cache.enable inputs.aagl.nixConfig;

      programs = {
        anime-game-launcher.enable = cfg.impact.enable;
        honkers-railway-launcher.enable = cfg.rail.enable;
        sleepy-launcher.enable = cfg.zone.enable;
      };
    };
}
