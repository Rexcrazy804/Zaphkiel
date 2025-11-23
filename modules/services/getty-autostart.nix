{
  dandelion.modules.getty-autostart = {
    config,
    lib,
    ...
  }: {
    services.getty.autologinUser = "rexies";
    programs.fish.loginShellInit =
      lib.mkIf config.programs.uwsm.enable
      ''
        if uwsm check may-start;
          exec uwsm start default
        end
      '';
  };
}
