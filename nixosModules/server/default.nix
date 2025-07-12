{lib, ...}: {
  imports = [
    ./tailscale.nix
    ./immich.nix
    ./openssh.nix
    ./jellyfin.nix
    ./minecraft
    ./fail2ban.nix
  ];

  options.zaphkiel.services.enable = lib.mkEnableOption "services";
}
