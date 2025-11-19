{
  dandelion.modules.caddy = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption mkIf mkAliasOptionModule mkOption;
    inherit (lib.types) singleLineStr;
    cfg = config.zaphkiel.services.caddy;
  in {
    imports = [
      (mkAliasOptionModule ["zaphkiel" "services" "caddy" "secretsFile"] ["services" "caddy" "environmentFile"])
    ];
    options.zaphkiel.services.caddy = {
      tsplugin = {
        enable = mkEnableOption "tailscale caddy plugin";
        revision = mkOption {
          type = singleLineStr;
          default = "v0.0.0-20250508175905-642f61fea3cc";
        };
        hash = mkOption {
          type = singleLineStr;
          default = "sha256-oYCY85/Sze17RhqMEfM7t80VXUXL5hpNAjtH75Il5yQ=";
          description = "Hash for the plugin";
        };
      };
    };

    config = {
      assertions = [
        {
          assertion = cfg.tsplugin.enable -> (cfg.secretsFile != null);
          message = "secretsFile must be provided to use tailsacle plugin";
        }
      ];

      services.caddy = {
        enable = true;
        package =
          if cfg.tsplugin.enable
          then
            pkgs.caddy.withPlugins {
              plugins = ["github.com/tailscale/caddy-tailscale@${cfg.tsplugin.revision}"];
              inherit (cfg.tsplugin) hash;
            }
          else pkgs.caddy;

        globalConfig = mkIf cfg.tsplugin.enable ''
          tailscale {
            auth_key {$TS_KEY}
          }
        '';
      };
    };
  };
}
