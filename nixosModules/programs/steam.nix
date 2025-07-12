{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zaphkiel.programs.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf config.zaphkiel.programs.steam.enable {
    programs.steam = {
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
