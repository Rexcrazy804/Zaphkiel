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
    nixvim = inputs.nixvim.packages.${pkgs.system}.default;
  in builtins.attrValues {
    inherit (pkgs) git lenovo-legion;
    inherit nixvim;
  };

  # wayland on electron and chromium based aps
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
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
