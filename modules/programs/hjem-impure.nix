{
  hjem-impure,
  self,
  ...
}: {
  dandelion.modules.hjem-impure = {...}: {
    imports = [self.dandelion.modules.hjem];
    hjem.extraModules = [hjem-impure.hjemModules.default];
  };
}
