{
  sources ? import ./npins,
  system ? builtins.currentSystem or "unknown-system",
  pkgs ? import sources.nixpkgs {inherit system;},
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  networking.hostName = "basicvm";
  system.stateVersion = "25.05";
  virtualisation = {
    graphics = false;
    diskSize = 10 * 1024;
    memorySize = 2 * 1024;
    cores = 2;
  };

  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.rexies = {
    enable = true;
    initialPassword = "rose";
    createHome = true;
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [];
  };
}
