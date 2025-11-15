# modules imported for EVERYTHING
{self, ...}: {
  dandelion.profiles.workstation = {
    imports = [
      self.dandelion.modules.firefox
      self.dandelion.modules.keyd
      self.dandelion.modules.gnupg
      self.dandelion.modules.audio
      self.dandelion.modules.boot
      self.dandelion.modules.fonts
      self.dandelion.modules.firmware
      self.dandelion.modules.bluetooth
      self.dandelion.modules.network
      self.dandelion.modules.graphics
      self.dandelion.modules.privoxy
    ];
  };
}
