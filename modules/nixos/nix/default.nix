{inputs, pkgs, ...}: {
  imports = [
    ./activation.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix = {
    # remove nix-channel related tools & configs, we use flakes instead.
    channel.enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;

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
}
