{sources, pkgs, ...}: {
  imports = [./activation.nix];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.flake.source = sources.nixpkgs;
  nix = {
    package = pkgs.nixVersions.nix_2_30;
    channel.enable = false;
    settings = {
      experimental-features = ["nix-command" "flakes"];
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
