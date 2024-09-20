{lib, ...}: {
  packages = {
    discord.enable = lib.mkForce false;
    obs.enable = lib.mkForce false;
    mangohud.enable = lib.mkForce false;
    mpv = {
      anime4k.enable = lib.mkForce false;
    };
  };

  packageGroup = {
    emulators.enable = lib.mkForce false;
  };
}
