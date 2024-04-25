{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
  };

  outputs = {
    self,
    nixpkgs,
    aagl,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      Zaphkiel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          # main
          ./nixos/configuration.nix

          # anime game launcher
          {
            imports = [ aagl.nixosModules.default ];
            nix.settings = aagl.nixConfig; # Set up Cachix
            programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
            programs.honkers-railway-launcher.enable = true;
          }
        ];
      };
    };
  };
}
