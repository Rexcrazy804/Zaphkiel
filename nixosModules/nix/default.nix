{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./activation.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
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
      trusted-users = ["root" "@wheel"];
    };

    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
