{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.flake-inputs) nixos-wsl;
  inherit (config.flake.paths) dots;
  inherit (config.flake.legacyPackages.${system}) sources;

  system = config.host-system;
  username = "nixos";
in {
  imports = [
    nixos-wsl.nixosModules.default

    # programs
    ../system/environment.nix
    ../programs/nix.nix
    ../programs/fish.nix
    ../programs/direnv.nix

    # hjem
    ../programs/hjem.nix
    ../programs/hjem-impure.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "Flora";

  wsl.enable = true;
  wsl.defaultUser = username;

  users.users.nixos = {
    shell = pkgs.fish;
    packages = [
      pkgs.btop
      pkgs.bat
      pkgs.delta
      pkgs.yazi
      pkgs.foot
      pkgs.radicle-tui
    ];
  };

  fonts = {
    fontDir.enable = true;
    packages = lib.attrValues {
      inherit (pkgs.nerd-fonts) caskaydia-mono caskaydia-cove;
    };
  };

  hjem.users.${username} = {
    enable = true;
    user = username;
    directory = config.users.users.${username}.home;
    clobberFiles = lib.mkForce true;
    impure = {
      enable = true;
      dotsDir = "${dots}";
      dotsDirImpure = "/home/nixos/nixos/dots";
      parseAttrs = [
        config.hjem.users.${username}.xdg.config.files
        config.hjem.users.${username}.xdg.state.files
      ];
    };

    files.xdg.config = let
      dots' = config.hjem.users.${username}.impure.dotsDir;
    in {
      "git/config" = dots' + "/git/config";
      "jj/config.toml" = dots' + "/jj/config.toml";
      "fish/themes" = sources.rosep-fish + "/themes";
      "fish/config.fish" = dots' + "/fish/config.fish";
      "bat/config" = dots' + "/bat/config";
      "bat/themes" = sources.catp-bat + "/themes";
      "yazi/yazi.toml" = dots' + "/yazi/yazi.toml";
      "yazi/keymap.toml" = dots' + "/yazi/keymap.toml";
      "foot/foot.ini" = dots' + "/foot/foot.ini";
      "foot/rose-pine.ini" = sources.rosep-foot + "/rose-pine";
    };
  };
}
