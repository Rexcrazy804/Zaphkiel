{...}: {
  imports = [
    ./server
    ./nix
    ./programs/direnv.nix
    ./programs/age.nix
    ./programs/booru-flake
    ./programs/fish.nix
    ./system/networking/dnsproxy2.nix
  ];
}
