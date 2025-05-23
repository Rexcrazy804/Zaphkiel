{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    booru-flake = {
      url = "github:Rexcrazy804/booru-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.generators.follows = "";
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

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
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
      quickshell = pkgs.callPackage ./users/Wrappers/quickshell.nix {
        quickshell = inputs.quickshell.packages.${pkgs.system}.default.override {
          withJemalloc = true;
          withQtSvg = true;
          withWayland = true;
          withX11 = false;
          withPipewire = true;
          withPam = true;
          withHyprland = true;
          withI3 = false;
        };
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
    nixosConfigurations = {
      Zaphkiel = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          users = ["rexies"];
        };
        modules = [
          ./hosts/Zaphkiel/configuration.nix
          ./nixosModules
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
          users = ["rexies"];
        };
        modules = [
          ./hosts/Seraphine/configuration.nix
          ./nixosModules
          ./users
        ];
      };

      Persephone = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
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

    devShells = forAllSystems (pkgs: {
      quickshell = let
        qs = inputs.quickshell.packages.${pkgs.system}.default.override {
          withJemalloc = true;
          withQtSvg = true;
          withWayland = true;
          withX11 = false;
          withPipewire = true;
          withPam = true;
          withHyprland = true;
          withI3 = false;
        };
        qtDeps = [
          qs
          pkgs.kdePackages.qtbase
          pkgs.kdePackages.qtdeclarative
        ];
      in
        pkgs.mkShell {
          shellHook = let
            qmlPath = pkgs.lib.pipe qtDeps [
              (builtins.map (lib: "${lib}/lib/qt-6/qml"))
              (builtins.concatStringsSep ":")
            ];
          in ''
            export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${qmlPath}"
            SHELL=nu exec nu # not using direnv for these shells
          '';
          buildInputs = qtDeps;
            packages = [
              pkgs.material-symbols
              pkgs.google-fonts
            ];
        };
    });
  };
}
