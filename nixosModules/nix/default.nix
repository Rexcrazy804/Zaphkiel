{sources, ...}: {
  imports = [./activation.nix];
  nixpkgs.config.allowUnfree = true;
  nix = {
    nixPath = ["nixpkgs=/etc/nixos/nixpkgs"];

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

  environment.etc = {
    "nixos/nixpkgs".source = sources.nixpkgs;
  };
}
