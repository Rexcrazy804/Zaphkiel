{inputs, ...}: {
  imports = [
    inputs.aagl.nixosModules.default
  ];

  # anime games launcher stuff
  nix.settings = inputs.aagl.nixConfig;
  programs = {
    anime-game-launcher.enable = false;
    honkers-railway-launcher.enable = true;
    sleepy-launcher.enable = true;
  };
}
