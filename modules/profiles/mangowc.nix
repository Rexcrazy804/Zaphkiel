# modules imported for EVERYTHING
{self, ...}: {
  dandelion.profiles.mangowc = {
    imports = [
      self.dandelion.modules.mangowc
      self.dandelion.modules.compositor-common
    ];
  };
}
