{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.steam.enable = lib.mkEnableOption "Enable steam";
  };

  config = lib.mkIf config.progModule.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs: [
          pkgs.mangohud
          pkgs.bottles
        ];
      };
    };
  };
}
