{
  lib,
  config,
  ...
}: {
  options.zaphkiel.programs.keyd.enable = lib.mkEnableOption "keyd";
  config =
    lib.mkIf config.zaphkiel.programs.keyd.enable {
    };
}
