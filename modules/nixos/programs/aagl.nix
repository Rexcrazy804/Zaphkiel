{lib, inputs, config, ...}: {
  imports = [
    inputs.aagl.nixosModules.default
  ];

  options = {
    anime-games.enable = lib.mkEnableOption "Enable a certain Anime Game";
  };

  config = lib.mkIf config.anime-games.enable {
    nix.settings = inputs.aagl.nixConfig;

    programs = {
      anime-game-launcher.enable = false;
      honkers-railway-launcher.enable = true;
      sleepy-launcher.enable = true;
    };
  };
}
