{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
        system:
          fn (import nixpkgs {
            system = system;
            overlays = [outputs.overlays.internal];
          })
      );
    sources = import ./npins;
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    overlays.internal = import ./overlay.nix {inherit sources;};

    packages = forAllSystems (pkgs: {
      catppuccin-bat = pkgs.catppuccin-bat;
      nixvim = pkgs.nixvim;
      quickshell = pkgs.callPackage ./pkgs/quickshell.nix {quickshell = pkgs.quickshell-nix;};
      kokCursor = pkgs.kokCursor;
      mpv = pkgs.mpv-wrapped.override {anime = true;};
      sddm-theme = pkgs.sddm-silent.override {theme = "rei";};
    });

    # WARNING
    # after sayonara-flakes is merged `nnixosConfigurations` are just here for
    # historical reasons or rather for people new to flakes to learn how
    # things were done before I dropped flakes
    nixosConfigurations = {
      # Computer die :kokokries:
      # Zaphkiel = nixpkgs.lib.nixosSystem {
      #   specialArgs = {
      #     inherit inputs outputs sources;
      #     users = ["rexies"];
      #   };
      #   modules = [
      #     ./hosts/Zaphkiel/configuration.nix
      #     ./nixosModules
      #     ./users
      #   ];
      # };

      Raphael = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs sources;
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
          inherit inputs outputs sources;
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
          inherit inputs outputs sources;
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
          inherit inputs outputs sources;
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
        path = ./templates/Rust/minimal;
        description = "Rust flake with oxalica overlay + mold linker";
        welcomeText = ''
          # A minimal rust template by Rexiel Scarlet (Rexcrazy804)
        '';
      };

      nix-minimal = {
        path = ./templates/Nix/minimal;
        description = "A minimal nix flake template with the lambda for ease of use";
        welcomeText = ''
          # A minimal nix flake template by Rexiel Scarlet (Rexcrazy804)
        '';
      };

      nix-npins = {
        path = ./templates/Nix/npins-compat;
        description = "A cursed npin-flake bridge template";
        welcomeText = ''
          # A cursed npin-flake bridge template by Rexiel Scarlet (Rexcrazy804)
        '';
      };

      vm-basic = {
        path = ./templates/Nix/basic-vm;
        description = "Basic npins based virtual machine template";
        welcomeText = ''
          # Npins based nixos container
          - simple config + script pair to get a working nixos virtual machine
        '';
      };

      java = {
        path = ./templates/Java;
        description = "I wish java was minimal";
        welcomeText = ''
          # A java template by Rexiel Scarlet (Rexcrazy804)
        '';
      };
    };

    devShells = forAllSystems (pkgs: {
      quickshell = let
        qtDeps = [
          # pkgs.quickshell depends on the internal overlay
          # see the top of this flake's outputs
          pkgs.quickshell
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
            SHELL=fish exec fish
          '';
          buildInputs = qtDeps;
          packages = [pkgs.material-symbols pkgs.google-fonts];
        };
    });
  };
}
