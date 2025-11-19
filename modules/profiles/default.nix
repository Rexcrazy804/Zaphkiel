{self, ...}: {
  dandelion.profiles.default = {
    imports = [
      self.dandelion.modules.agenix
      self.dandelion.modules.hjem
      self.dandelion.modules.zaphkiel-data
      self.dandelion.modules.locales
      # programs
      self.dandelion.modules.environment
      self.dandelion.modules.nix
      self.dandelion.modules.fish
      self.dandelion.modules.direnv
      self.dandelion.modules.shpool
      self.dandelion.modules.matugen
      # network
      self.dandelion.modules.dnscrypt
      self.dandelion.modules.tailscale
      self.dandelion.modules.openssh
      # hardware
      self.dandelion.modules.undetected
    ];
  };
}
