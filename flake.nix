{
  description = "Rexiel Scarlet's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # hard to remove this crap
    # TODO write the overlay on my own
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
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
        system:
          fn (import nixpkgs {
            system = system;
            overlays = [outputs.overlays.internal];
          })
      );
    npins = import ./npins;
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    overlays.internal = final: prev: {
      quickshell = final.callPackage npins.quickshell {
        gitRev = npins.quickshell.revision;
        withJemalloc = true;
        withQtSvg = true;
        withWayland = true;
        withX11 = false;
        withPipewire = true;
        withPam = true;
        withHyprland = true;
        withI3 = false;
      };
      # nixpkgs version of quickshell for liverunning only
      quickshell-nix = prev.quickshell;
      kokCursor = final.callPackage ./pkgs/kokCursor.nix {};
      nixvim = final.callPackage ./pkgs/nvim {};
      mpv-wrapped = final.callPackage ./pkgs/mpv {};
      catppuccin-bat = final.callPackage ./pkgs/catppuccin-bat.nix {};
      sddm-silent = final.callPackage npins.silent-sddm {gitRev = npins.silent-sddm.revision;};
    };

    packages = forAllSystems (pkgs: {
      catppuccin-bat = pkgs.catppuccin-bat;
      nixvim = pkgs.nixvim;
      quickshell = pkgs.callPackage ./pkgs/quickshell.nix {quickshell = pkgs.quickshell-nix;};
      kokCursor = pkgs.kokCursor;
      mpv = pkgs.mpv-wrapped.override {anime = true;};
      sddm-theme = pkgs.sddm-silent.override {theme = "rei";};
    });

    nixosConfigurations = {
      # Computer die :kokokries:
      # Zaphkiel = nixpkgs.lib.nixosSystem {
      #   specialArgs = {
      #     inherit inputs outputs;
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
          inherit inputs outputs;
          users = ["rexies" "ancys"];
          sources = npins;
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
          sources = npins;
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
          sources = npins;
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
          sources = npins;
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
