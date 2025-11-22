{
  dandelion.modules.zaphkiel-data = {
    lib,
    config,
    ...
  }: let
    inherit (lib) mkOption;
    inherit (lib.types) listOf path str;
  in {
    options.zaphkiel.data = {
      users = mkOption {
        type = listOf str;
        default = [];
        description = "list of users (duh)";
      };
      wallpaper = mkOption {
        type = path;
        description = "wallpaper path (duh)";
      };
      tailscale = mkOption {
        readOnly = true;
        default = lib.fix (self: {
          Persephone = {
            ipv4 = "100.110.70.18";
            ipv6 = "fd7a:115c:a1e0::6a01:4614";
          };
          Aphrodite = {
            ipv4 = "100.121.86.4";
            ipv6 = "fd7a:115c:a1e0::6e01:5604";
          };
          Seraphine = {
            ipv4 = "100.112.116.17";
            ipv6 = "fd7a:115c:a1e0::eb01:7412";
          };
          self = self.${config.networking.hostName};
        });
      };
    };
  };
}
