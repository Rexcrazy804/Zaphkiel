{
  config,
  lib,
  ...
}: let
  inherit (lib) toLower;
  inherit (config.networking) hostName;

  username = "rexies";
  dots = config.hjem.users.${username}.impure.dotsDir;
in {
  hjem.users.${username}.xdg.config.files = {
    "mango/config.conf".source = dots + "/mango/config.conf";
    "mango/autostart.sh".source = dots + "/mango/autostart.sh";
    "mango/hardware.conf".source = dots + "/mango/${toLower hostName}.conf";
  };
}
