# modules imported for EVERYTHING
{self, ...}: {
  dandelion.profiles.gaming = {
    imports = [
      self.dandelion.modules.wine
      self.dandelion.modules.proton
      self.dandelion.modules.sunshine
      self.dandelion.modules.hjem-games
    ];
  };
}
