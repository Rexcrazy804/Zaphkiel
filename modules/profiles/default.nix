# modules imported for EVERYTHING
{self, ...}: {
  dandelion.profiles.default = {
    imports = [
      self.dandelion.modules.zaphkiel-data
      self.dandelion.modules.agenix
      self.dandelion.modules.hjem
      self.dandelion.modules.fish
      self.dandelion.modules.nix
      self.dandelion.modules.matugen
      self.dandelion.modules.locales
      self.dandelion.modules.dnscrypt
      self.dandelion.modules.environment
    ];
  };
}
