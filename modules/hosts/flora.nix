{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.paths) dots;
  inherit (inputs.self.legacyPackages.${system}) sources;

  username = "nixos";
in {
  imports = [
    inputs.nixos-wsl.nixosModules.default

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

    xdg.config.files = let
      dots' = config.hjem.users.${username}.impure.dotsDir;
    in {
      "git/config".source = dots' + "/git/config";
      "jj/config.toml".source = dots' + "/jj/config.toml";
      "fish/themes".source = sources.rosep-fish + "/themes";
      "fish/config.fish".source = dots' + "/fish/config.fish";
      "bat/config".source = dots' + "/bat/config";
      "bat/themes".source = sources.catp-bat + "/themes";
      "yazi/yazi.toml".source = dots' + "/yazi/yazi.toml";
      "yazi/keymap.toml".source = dots' + "/yazi/keymap.toml";
      "foot/foot.ini".source = dots' + "/foot/foot.ini";
      "foot/rose-pine.ini".source = sources.rosep-foot + "/rose-pine";
    };
  };
}
