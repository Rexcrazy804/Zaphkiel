{
  dandelion.modules.getty-autostart = {
    config,
    lib,
    ...
  }: {
    services.getty = {
      autologinUser = "rexies";
      autologinOnce = true;
    };
    programs.fish.loginShellInit =
      lib.mkIf config.programs.uwsm.enable
      ''
        if uwsm check may-start;
          exec uwsm start default
        end
      '';
  };
}
