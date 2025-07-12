{lib, config, ...}: {
  imports = [
    ./amd.nix
    ./nvidia.nix
    ./intel.nix
  ];
  config = lib.mkIf (!config.zaphkiel.data.headless) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
