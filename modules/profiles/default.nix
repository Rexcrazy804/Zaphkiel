{
  imports = [
    ../utils/zaphkiel-data.nix

    ../programs/age.nix
    ../programs/hjem.nix
    ../programs/hjem-impure.nix

    ../system/locales.nix
    ../system/environment.nix

    ../programs/nix.nix
    ../programs/fish.nix
    ../programs/direnv.nix
    ../programs/shpool.nix

    ../services/dnscrypt.nix
    ../services/tailscale.nix
    ../services/openssh.nix

    ../hardware/undetected.nix
  ];

  hjem.extraModules = [
    ../programs/hjem-matugen.nix
  ];
}
