{
  imports = [
    ../programs/wine.nix
    ../programs/proton.nix
    ../services/sunshine.nix
  ];

  hjem.extraModules = [
    ../utils/hjem-games.nix
  ];
}
