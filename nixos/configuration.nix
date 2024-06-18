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
  ];

  environment.systemPackages =
    [
      inputs.nixvim.packages.${pkgs.system}.default
    ]
    ++ (with pkgs; [
      # neovim
      git
      lenovo-legion
    ]);

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
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
}
