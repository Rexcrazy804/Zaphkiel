{
  lib,
  config,
  ...
}: {
  options = {
    progModule.gdm = {
      enable = lib.mkEnableOption "Enable gdm";
    };
  };

  config = lib.mkIf config.progModule.gdm.enable {
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
      settings = {
        greeter = {
          Include = builtins.concatStringsSep "," config.zaphkiel.data.users;
        };
      };
      banner = ''こんにちは'';
    };

    systemd.tmpfiles.rules = lib.pipe config.zaphkiel.data.users [
      (builtins.filter (user: config.hjem.users.${user}.files.".face.icon".source != null))
      (builtins.map (user: [
        "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
        "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${config.hjem.users.${user}.files.".face.icon".source}"
      ]))
      (lib.flatten)
    ];
  };
}
