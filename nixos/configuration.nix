# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ./graphics.nix
    ./hardware-configuration.nix
    ./locales.nix
    ./networking.nix
    ./services.nix
    ./users.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["ntfs"];

  nixpkgs.config.allowUnfree = true;
  programs.neovim.defaultEditor = true;
  environment.systemPackages = with pkgs; [
    git
    lenovo-legion

    # obs specific configuration
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 8d";
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
