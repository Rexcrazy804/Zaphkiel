{...}: {
  imports = [
    ./amd.nix
    ./nvidia.nix
    ./intel.nix
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
