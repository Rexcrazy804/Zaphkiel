{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    aagl,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.${system}.alejandra;
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      Zaphkiel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          # main
          ./nixos/configuration.nix

          # anime game launcher
          {
            imports = [aagl.nixosModules.default];
            programs.anime-game-launcher.enable = false;
            programs.honkers-railway-launcher.enable = true;
          }
        ];
      };
    };
  };
}
