{
  self,
  nixos-wsl,
  ...
}: let
  inherit (self.lib) mkDotsModule;
  username = "nixos";
in {
  dandelion.hosts.Flora = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [
      nixos-wsl.nixosModules.default

      # programs
      self.dandelion.modules.environment
      self.dandelion.modules.nix
      self.dandelion.modules.fish
      self.dandelion.modules.direnv

      # hjem
      self.dandelion.modules.hjem
      self.dandelion.modules.hjem-impure
      self.dandelion.dots.nixos
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
        dotsDir = "${self.paths.dots}";
        dotsDirImpure = "/home/nixos/nixos/dots";
        parseAttrs = [
          config.hjem.users.${username}.xdg.config.files
          config.hjem.users.${username}.xdg.state.files
        ];
      };
    };
  };

  dandelion.dots.nixos = mkDotsModule username {
    # terminal
    "git/config" = "/git/config";
    "fish/themes" = {sources, ...}: sources.rosep-fish + "/themes";
    "fish/config.fish" = "/fish/config.fish";
    # NOTE: required bat cache --build before theme can be used
    "bat/config" = "/bat/config";
    "bat/themes" = {sources, ...}: sources.catp-bat + "/themes";
    "yazi/yazi.toml" = "/yazi/yazi.toml";
    "yazi/keymap.toml" = "/yazi/keymap.toml";
    "foot/foot.ini" = "/foot/foot.ini";
    "foot/rose-pine.ini" = {sources, ...}: sources.rosep-foot + "/rose-pine";
  };
}
