{
  lib,
  config,
  ...
}: {
  imports = [
    ./amd.nix
    ./nvidia.nix
    ./intel.nix
  ];

  options.zaphkiel.graphics.enable = lib.mkEnableOption "graphics";

  config = lib.mkIf (config.zaphkiel.graphics.enable) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
