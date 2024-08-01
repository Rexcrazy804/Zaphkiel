{...}: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
    ../../users/rexies
  ];

  networking.hostName = "Zaphkiel";

  system.stateVersion = "23.11";
}
