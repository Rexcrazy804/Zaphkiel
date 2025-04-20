{...}: {
  imports = [
    ./server
    ./nix
    ./programs/direnv.nix
    ./programs/age.nix
    ./system/networking/dnsproxy2.nix
  ];
}
