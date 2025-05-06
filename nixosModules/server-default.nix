{...}: {
  imports = [
    ./server
    ./nix
    ./programs/direnv.nix
    ./programs/age.nix
    ./programs/booru-flake
    ./system/networking/dnsproxy2.nix
  ];
}
