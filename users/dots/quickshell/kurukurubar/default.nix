{sources ? import ../../../../npins}: let
  pkgs' = import ../../../../pkgs {inherit sources;};
  hyprConf = pkgs'.writeText "hyprland.conf" ''
    monitor = ,preferred, auto, 1
    exec-once = QS_DISPLAY_MANAGER=1 kurukurubar -d && kurukurubar ipc call lockscreen lock

    misc {
      force_default_wallpaper = 1 # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
    }
  '';
  overlays = pkgs'.overlays;
in
  import (sources.nixpkgs + "/nixos/lib/eval-config.nix") {
    system = null;
    specialArgs = {inherit sources;};
    modules = [
      # required to get my overlay
      {nixpkgs.overlays = overlays;}
      ({
        modulesPath,
        pkgs,
        lib,
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

        environment.systemPackages = [(pkgs.kurukurubar-unstable.override {asGreeter = false;})];
        users.users.rexies = {
          enable = true;
          initialPassword = "kokomi";
          createHome = true;
          isNormalUser = true;
          extraGroups = ["wheel"];
          packages = [];
        };

        programs.hyprland.enable = true;

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.hyprland}/bin/hyprland --config ${hyprConf}";
            };
          };
        };
        nixpkgs.hostPlatform = "x86_64-linux";
      })
    ];
  }
