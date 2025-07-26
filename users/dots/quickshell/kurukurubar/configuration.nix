# WARNING
# this is a merely a configuration used to test the kurukuru greeter
{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  networking.hostName = "basicvm";
  system.stateVersion = "25.05";
  virtualisation = {
    diskSize = 10 * 1024;
    memorySize = 2 * 1024;
    cores = 2;
  };

  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.rexies = {
    enable = true;
    initialPassword = "kokomi";
    createHome = true;
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [];
  };

  users.users.kokomi = {
    enable = true;
    initialPassword = "rexies";
    createHome = true;
    isNormalUser = true;
    packages = [];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.sway.enable = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.kurukuruDM = {
    enable = true;
    settings = {
      # wallpaper = pkgs.booru-images.i2768802;
      instantAuth = false;
      default_user = "rexies";
      default_session = "sway";
    };
  };
}
