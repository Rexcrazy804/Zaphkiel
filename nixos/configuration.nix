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

  environment.systemPackages = with pkgs; [
    neovim
    git
    lenovo-legion
  ];

  # wayland on electron and chromium based aps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      extra-substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://aseipp-nix-cache.global.ssl.fastly.net"
      ];
      extra-trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
