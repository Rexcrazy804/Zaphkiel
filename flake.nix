{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:Rexcrazy804/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # don't even know if darwin can generate the nvim but here we are
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system: fn (import nixpkgs {system = system;})
      );
  in {
    packages = forAllSystems (pkgs: let
      nvimPkgs = import ./users/Wrappers/nvim/default.nix {
        pkgs = pkgs;
        lib = pkgs.lib;
      };
    in {
      nvim-no-lsp = nvimPkgs.nvim-no-lsp;
      nvim-wrapped = nvimPkgs.nvim-wrapped;
      default = nvimPkgs.nvim-wrapped; # use nvim-no-lsp for a minimal setup
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = {
      Zaphkiel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

          # every user in this list must have a username.nix under users/
          # and another homeManagerModules/Users/
          users = ["rexies"];
        };
        modules = [
          ./hosts/Zaphkiel/configuration.nix
          ./nixosModules

          # responsible for importing home manager modules & users
          ./users
          ./pkgs/overlay.nix
        ];
      };

      Raphael = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          users = ["rexies" "ancys"];
        };
        modules = [
          ./hosts/Raphael/configuration.nix
          ./nixosModules
          ./users
          ./pkgs/overlay.nix
        ];
      };

      Seraphine = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

          # every user in this list must have a username.nix under users/
          # and another homeManagerModules/Users/
          users = ["rexies"];
        };
        modules = [
          ./hosts/Seraphine/configuration.nix
          ./nixosModules

          # responsible for importing home manager modules & users
          ./users
          ./pkgs/overlay.nix
        ];
      };

      Aphrodite = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

          # every user in this list must have a username.nix under users/
          # and another homeManagerModules/Users/
          users = ["rexies" "sivanis"];
        };
        modules = [
          ./hosts/Aphrodite/configuration.nix
          ./users
          ./pkgs/overlay.nix
        ];
      };
    };

    templates = {
      rust-minimal = {
        path = ./Templates/Rust/minimal;
        description = "Rust flake with oxalica overlay + mold linker";
        welcomeText = ''
          # A minimal rust template by Rexiel Scarlet (Rexcrazy804)
        '';
      };
    };
  };
}
