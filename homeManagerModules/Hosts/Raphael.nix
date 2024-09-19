{lib, ...}: {
  packages = {
    mpv = {
      anime4k.enable = lib.mkForce false;
    };
  };

  packageGroup = {
    emulators.enable = lib.mkForce false;
  };
}
