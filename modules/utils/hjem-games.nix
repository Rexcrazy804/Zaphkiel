{self, ...}: {
  dandelion.modules.hjem-games = {
    hjem.extraModules = [(self.paths.specials + /hjemGames.nix)];
  };
}
