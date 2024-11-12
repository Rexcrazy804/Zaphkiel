{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
  ];

  options = {
    progModule.anime-games.enable = lib.mkEnableOption "Enable Anime Games";
  };

  config = lib.mkIf config.progModule.anime-games.enable {
    nix.settings = inputs.aagl.nixConfig;
    programs = {
      anime-game-launcher.enable = lib.mkDefault false;
      honkers-railway-launcher.enable = lib.mkDefault true;
      sleepy-launcher.enable = lib.mkDefault true;
    };
  };
}
