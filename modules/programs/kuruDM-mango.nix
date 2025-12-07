{self, ...}: {
  dandelion.modules.kuruDM-mango = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # use mangowc as base for kurukuruDM
    services.greetd.settings.default_session.command = let
      cfg = config.programs.kurukuruDM;
      autostart = pkgs.writeShellScript "autostart.sh" ''
        ${cfg.finalOpts} ${cfg.package}/bin/kurukurubar && pkill mango
      '';
      mangoConf = pkgs.writeText "config.conf" ''
        monitorrule=eDP-1,1,1,tile,0,1.25,0,0,1920,1080,60
        cursor_theme=Kokomi_Cursor
        exec-once = ${autostart}
      '';
    in
      lib.mkForce "env ${self.packages.${pkgs.stdenv.hostPlatform.system}.mangowc}/bin/mango -c ${mangoConf}";
  };
}
