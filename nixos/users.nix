{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.aagl.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.rexies = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = "Rexiel Scarlet";
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rexies = import ../home;
  };

  # anime games launcher stuff
  nix.settings = inputs.aagl.nixConfig;
  programs = {
    anime-game-launcher.enable = false;
    honkers-railway-launcher.enable = true;
  };

  # specials might relocate later, let it be here for the time being
  programs = {
    partition-manager.enable = true;
    mosh.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: [
          pkgs.mangohud
        ];
      };
    };
  };
}
