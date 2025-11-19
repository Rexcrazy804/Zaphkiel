{
  dandelion.modules.zaphkiel-data = {lib, ...}: let
    inherit (lib) mkOption;
    inherit (lib.types) listOf path str;
  in {
    options = {
      zaphkiel = {
        data.users = mkOption {
          type = listOf str;
          default = [];
          description = "list of users (duh)";
        };
        data.wallpaper = mkOption {
          type = path;
          description = "wallpaper path (duh)";
        };
      };
    };
  };
}
