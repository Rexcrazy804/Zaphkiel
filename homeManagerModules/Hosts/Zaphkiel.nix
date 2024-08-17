{lib, ...}: {
  # entry point for tuning options for each system has higher priority than
  # user [mk force here] generally use this to override what the user.nix has
  # enabled. [primarily for disabling shit like say some games/multimedia apps
  # on a office computer]

  # packages.alacritty.enable = lib.mkForce false;

  packageGroup = {
    emulators.enable = lib.mkForce false;
  };
}
