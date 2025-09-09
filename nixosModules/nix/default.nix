{
  pkgs,
  sources,
  ...
}: {
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

      extra-substituters = ["https://rexielscarlet.cachix.org"];
      extra-trusted-public-keys = ["rexielscarlet.cachix.org-1:wGoHtlmAIuGW/LgcqtFLb1RhgGZaUYGys8Okpopt3A0="];
    };
    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
