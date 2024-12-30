{lib, ...}: {
  imports = [
    ./tailscale.nix
    ./immich.nix
    ./openssh.nix
    ./jellyfin.nix
    ./minecraft
  ];

  options.servModule.enable = lib.mkEnableOption "Enable Server Modules";
}
