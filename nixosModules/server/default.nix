{lib, ...}: {
  imports = [
    ./tailscale.nix
    ./immich.nix
    ./openssh.nix
  ];

  options.servModule.enable = lib.mkEnableOption "Enable Server Modules";
}
