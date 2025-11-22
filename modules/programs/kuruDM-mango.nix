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
    in let
      mangoConfDir = pkgs.linkFarmFromDrvs "mango" [
        (pkgs.writeShellScript "autostart.sh" ''
          ${cfg.finalOpts} ${cfg.package}/bin/kurukurubar && pkill mango
        '')
        (pkgs.writeText "config.conf" ''
          monitorrule=eDP-1,1,1,tile,0,1.25,0,0,1920,1080,60
          cursor_theme=Kokomi_Cursor
        '')
      ];
    in
      lib.mkForce "env MANGOCONFIG=${mangoConfDir} ${self.packages.${pkgs.system}.mangowc}/bin/mango";
  };
}
