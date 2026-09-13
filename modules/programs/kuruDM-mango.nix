{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) mangowc;
in {
  # use mangowc as base for kurukuruDM
  services.greetd.settings.default_session.command = let
    cfg = config.programs.kurukuruDM;
    autostart = pkgs.writeShellScript "autostart.sh" ''
      ${cfg.finalOpts} ${cfg.package}/bin/kurukurubar && pkill mango
    '';
    mangoConf = pkgs.writeText "config.conf" ''
      monitorrule=name:eDP-1,width:1920,height:1080,refresh:60,x:0,y:0,scale:1,vrr:0,rr:0
      cursor_theme=Kokomi_Cursor
      exec-once = ${autostart}
    '';
  in
    lib.mkForce "env ${mangowc}/bin/mango -c ${mangoConf}";
}
