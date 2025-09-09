{
  # WARN
  # This flake solely exists for the purpose of allowing overrides for flake
  # users which is why there does not exist a flake.lock in this repo. This
  # flake DOES NOT setup anything for my nixos configurations please see
  # `default.nix`.nixosConfigurations for that

  # INFO
  # For non flake users please see default.nix primarilly supports npins (v6) sources.
  # Feel welcome to raise any concerns

  description = "Rexiel Scarlet's Flake bridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    quickshell.url = "github:quickshell-mirror/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = fn:
      nixpkgs.lib.genAttrs (import inputs.systems) (
        system:
          fn nixpkgs.legacyPackages.${system}
      );

    zaphkiel = system:
      import ./default.nix {
        inherit (inputs.quickshell.packages.${system}) quickshell;
        pkgs = import nixpkgs {inherit system;};
        # fear not flake cuties, this is a bridge to the npins side
        sources = {};
      };
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: let
      zaphkiel' = zaphkiel pkgs.system;
    in {
      inherit (zaphkiel'.packages) xvim nixvim nixvim-minimal kokCursor kurukurubar kurukurubar-unstable booru-images librebarcode;
      quickshell = pkgs.lib.warn "prefer #kurukurubar instead. #quickshell will be removed soon" zaphkiel'.packages.kurukurubar;
      mpv = zaphkiel'.packages.mpv-wrapped.override {anime = true;};
    });

    # some code duplication here but its better that we do this rather than get
    # it through the default.nix due to infinite recursion reasons
    nixosModules = {
      kurukuruDM = {
        pkgs,
        lib,
        ...
      }: {
        imports = [./nixosModules/exported/kurukuruDM.nix];

        nixpkgs.overlays = [
          (final: prev: {inherit (self.packages.${pkgs.system}) kurukurubar kurukurubar-unstable;})
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

      rust-npins = {
        path = ./templates/Rust/npins-minimal;
        description = "Rust npins template with oxalica overlay + mold linker";
        welcomeText = ''
          # A minimal rust template
          - oxalica rust overlay
          - npins based tempalte

          ## WARNING
          - you must run `npins init` after pulling this template to generate `npins/default.nix`
          - the sources are locked with `npins/sources.json` and can be updated via `npins update`

          > In the event that these steps fail, please open an issue on Rexcrazy804/Zaphkiel
        '';
      };

      nix-minimal = {
        path = ./templates/Nix/minimal;
        description = "A minimal nix flake template with the lambda for ease of use";
        welcomeText = ''
          # A minimal nix flake template by Rexiel Scarlet (Rexcrazy804)
        '';
      };

      vm-basic = {
        path = ./templates/Nix/basic-vm;
        description = "Basic npins based virtual machine template";
        welcomeText = ''
          # Npins based nixos container template
          - simple vm template orchestrated by npins
          - depends solely on nixpkgs

          ## instructions
          - `default.nix` is your configuration.nix to build upon
          - utilize the `build.sh` script to build the vm
          - the built vm can be run via `./result/bin/run-basicvm-vm`
          - initial username is `rexies` and password is `kokomi`
          - to exit the vm run `sudo poweroff`

          ##  WARNING
          - `npins/` is not provided, please generate it with `npins init`
          - `chmod u+x build.sh` if it is not executable

          > template provided by Rexcrazy804/Zaphkiel
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
  };
}
