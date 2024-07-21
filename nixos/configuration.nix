{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./graphics.nix
    ./hardware-configuration.nix
    ./locales.nix
    ./networking.nix
    ./services.nix
    ./users.nix
    ./boot.nix
    ./fonts.nix
  ];

  environment.systemPackages = let
    wallpaper = ../home/dots/sddm-wall.png;
  in
    builtins.attrValues {
      inherit (pkgs) git lenovo-legion;

      sddm-astronaut = pkgs.sddm-astronaut.override {
        themeConfig = {
          Background = "${wallpaper}";
          PartialBlur = "true";
          BlurRadius = "45";
          ForceHideVirtualKeyboardButton = "true";
          FormPosition = "right";
        };
      };

      nixvim = inputs.nixvim.packages.${pkgs.system}.default;
    };

  # wayland on electron and chromium based apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      echo
      ${pkgs.nushell}/bin/nu -c "let diff_closure = ${pkgs.nix}/bin/nix store diff-closures /run/current-system '$systemConfig'; if \$diff_closure != \"\" {
        let table = \$diff_closure
        | lines
        | where \$it =~ KiB
        | where \$it =~ →
        | parse -r '^(?<Package>\S+): (?<Old_Version>[^,]+)(?:.*) → (?<New_Version>[^,]+)(?:.*, )(?<DiffBin>.*)$'
        | insert Diff {
          get DiffBin
          | ansi strip
          | str trim -l -c '+'
          | into filesize
        }
        | reject DiffBin
        | sort-by -r Diff; print \$table; \$table
        | math sum
      }"
    fi
  '';

  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this
  # flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix = {
    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by
    # this flake.
    registry.nixpkgs.flake = inputs.nixpkgs;

    # remove nix-channel related tools & configs, we use flakes instead.
    channel.enable = false;

    settings = {
      nix-path = pkgs.lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
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
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
