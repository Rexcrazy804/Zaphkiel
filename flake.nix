{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:Rexcrazy804/nixvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.alejandra;
    nixosConfigurations = {
      Zaphkiel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          home-manager.nixosModules.home-manager

          ./hosts/Zaphkiel/configuration.nix
          ./nixosModules
          ./users/rexies.nix
        ];
      };
    };
  };
}
