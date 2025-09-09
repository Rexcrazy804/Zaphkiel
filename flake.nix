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

    templates = import ./templates;
  };
}
