{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    booru-flake = {
      url = "github:Rexcrazy804/booru-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
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
      nvimPkgs = pkgs.callPackage ./users/Wrappers/nvim/default.nix {};
    in rec {
      inherit (nvimPkgs) nvim-no-lsp nvim-wrapped;
      default = nvim-wrapped;
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
        ];
      };

      Persephone = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;

          # every user in this list must have a username.nix under users/
          # and another homeManagerModules/Users/
          users = ["rexies"];
        };
        modules = [
          ./hosts/Persephone/configuration.nix
          ./nixosModules
          ./users
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
          ./nixosModules/server-default.nix
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

      nix-minimal = {
        path = ./Templates/Nix/minimal;
        description = "A minimal nix flake template with the lambda for ease of use";
        welcomeText = ''
          # A minimal nix flake template by Rexiel Scarlet (Rexcrazy804)
        '';
      };

      java = {
        path = ./Templates/Java;
        description = "I wish java was minimal";
        welcomeText = ''
          # A java template by Rexiel Scarlet (Rexcrazy804)
        '';
      };
    };
  };
}
