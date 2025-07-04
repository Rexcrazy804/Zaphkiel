{
  description = "Rexiel Scarlet's NixOS Configuration";
  # where is inputs.nixpkgs?
  # I ate it nyom :P

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    sources = import ./npins;
    nixpkgs = (import sources.flake-compat {src = sources.nixpkgs;}).outputs;

    forAllSystems = fn:
      nixpkgs.lib.genAttrs systems (
        system:
          fn (import nixpkgs {
            system = system;
            overlays = [outputs.overlays.internal];
          })
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    overlays.internal = import ./pkgs/overlays/internal.nix {inherit sources;};

    # NOTE
    # these rely on the internal overlay being applied
    # see the forAllSystems funciton
    packages = forAllSystems (pkgs: {
      inherit (pkgs) nixvim nixvim-minimal kokCursor kurukurubar sddm-silent-custom;
      quickshell = pkgs.lib.warn "prefer #kurukurubar instead. #quickshell will be removed soon" pkgs.kurukurubar;
      mpv = pkgs.mpv-wrapped.override {anime = true;};
    });

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

    # for a non flake version take a look at ./users/dots/quickshell/
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

    # WARNING
    # after sayonara-flakes is merged `nnixosConfigurations` are just here for
    # historical reasons or rather for people new to flakes to learn how
    # things were done before I dropped flakes
    # nixosConfigurations' = {
    #   # Computer die :kokokries:
    #   Zaphkiel = nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs outputs sources;
    #       users = ["rexies"];
    #     };
    #     modules = [
    #       ./hosts/Zaphkiel/configuration.nix
    #       ./nixosModules
    #       ./users
    #     ];
    #   };
    #
    #   Raphael = nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs outputs sources;
    #       users = ["rexies" "ancys"];
    #     };
    #     modules = [
    #       ./hosts/Raphael/configuration.nix
    #       ./nixosModules
    #       ./users
    #     ];
    #   };
    #
    #   Seraphine = nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs outputs sources;
    #       users = ["rexies"];
    #     };
    #     modules = [
    #       ./hosts/Seraphine/configuration.nix
    #       ./nixosModules
    #       ./users
    #     ];
    #   };
    #
    #   Persephone = nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs outputs sources;
    #       users = ["rexies"];
    #     };
    #     modules = [
    #       ./hosts/Persephone/configuration.nix
    #       ./nixosModules
    #       ./users
    #     ];
    #   };
    #
    #   Aphrodite = nixpkgs.lib.nixosSystem {
    #     specialArgs = {
    #       inherit inputs outputs sources;
    #       users = ["rexies" "sivanis"];
    #     };
    #     modules = [
    #       ./hosts/Aphrodite/configuration.nix
    #       ./users
    #       ./nixosModules/server-default.nix
    #     ];
    #   };
    # };
  };
}
