{lib, ...}: {
  imports = [
    ./amd.nix
    ./nvidia.nix
  ];

  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  options = {
    graphics = {
      amd.enable = lib.mkEnableOption "Enable amd graphics card";
      nvidia = {
        enable = lib.mkEnableOption "Enable nVidia graphics card";
      };
    };
  };
}
