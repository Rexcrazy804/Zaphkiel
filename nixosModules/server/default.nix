{lib, ...}: {
  imports = [
    ./tailscale.nix
    ./immich.nix
    ./openssh.nix
    ./minecraft.nix
  ];

  options.servModule.enable = lib.mkEnableOption "Enable Server Modules";
}
