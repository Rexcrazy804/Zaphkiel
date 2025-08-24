{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption literalExpression pipe map flatten;
  inherit (lib.types) submodule listOf str;

  cfg = config.zaphkiel.programs.privoxy;

  forwardAttr = submodule {
    options = {
      domains = mkOption {
        type = listOf str;
        default = [];
      };
      proxy = mkOption {
        type = str;
        default = "100.121.86.4:8888";
      };
    };
  };
in {
  options.zaphkiel.programs.privoxy = {
    enable = mkEnableOption "privoxy";
    forwards = mkOption {
      type = listOf forwardAttr;
      default = [];
      apply = x:
        pipe x [
          (map (x: map (domain: "${domain} ${x.proxy}") x.domains))
          flatten
        ];
      example = literalExpression ''
        [
          {
            domains = ["coolsite.org" "r69.xxx"];
            proxy = "2.1.2.1:900";
          }
        ]
      '';
    };
  };
  config = mkIf cfg.enable {
    services.privoxy = {
      enable = true;
      settings = {
        listen-address = "127.0.0.1:8118";
        forward = cfg.forwards;
      };
    };
    networking.proxy.default = "http://127.0.0.1:8118";
  };
}
