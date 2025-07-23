# WARNING
# this is a merely a configuration used to test the kurukuru greeter
{
  modulesPath,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.services.displayManager) sessionPackages;
  inherit (lib) concatStringsSep mapAttrs attrValues;
  kuruOpts = {
    KURU_DM_WALLPATH = pkgs.booru-images.i2768802;
    KURU_DM_SESSIONS = concatStringsSep ":" sessionPackages;
  };
  optsToString = concatStringsSep " " (attrValues (mapAttrs (k: v: "${k}=\"${v}\"") kuruOpts));
  hyprConf = pkgs.writeText "hyprland.conf" ''
    monitor = ,preferred, auto, auto
    exec-once = ${optsToString} kurukurubar && pkill Hyprland
    debug {
      disable_logs = false
    }

    misc {
      force_default_wallpaper = 1 # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
    }
  '';
in {
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

  environment.systemPackages = [(pkgs.kurukurubar-unstable.override {asGreeter = true;})];

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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/hyprland --config ${hyprConf}";
      };
    };
  };
  nixpkgs.hostPlatform = "x86_64-linux";
}
