{lib, ...}: {
  imports = [
    ./tailscale.nix
    ./immich.nix
    ./openssh.nix
    ./jellyfin.nix
    ./minecraft
    ./fail2ban.nix
  ];

  options.servModule.enable = lib.mkEnableOption "Enable Server Modules";
}
