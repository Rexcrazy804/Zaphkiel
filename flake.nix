{
  description = "Rexiel Scarlet's Flake bridge";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    quickshell.url = "github:Rexcrazy804/quickshell?ref=overridable-qs-unwrapped";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs callPackageWith warn;

    systems = import inputs.systems;
    eachSystem = system: nixpkgs.legacyPackages.${system};
    pkgsFor = fn: genAttrs systems (system: fn (eachSystem system));
    sources = import ./npins {};
  in {
    formatter = pkgsFor (pkgs: pkgs.alejandra);

    packages = pkgsFor (pkgs: let
      self' = self.packages.${pkgs.system};
      callPackage = callPackageWith (pkgs // self.packages.${pkgs.system});
    in {
      # kurukuru
      quickshell = callPackage ./pkgs/quickshell.nix {
        inherit
          (inputs.quickshell.packages.${pkgs.system})
          quickshell
          quickshell-unwrapped
          ;
      };
      kurukurubar-unstable = callPackage ./pkgs/kurukurubar.nix {};
      kurukurubar = (self'.kurukurubar-unstable).override {
        inherit (pkgs) quickshell;
        # following zaphkiel master branch: quickshell v0.2.0
        # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
      };

      # trivial
      mpv-wrapped = callPackage ./pkgs/mpv {};
      librebarcode = callPackage ./pkgs/librebarcode.nix {};
      kokCursor = callPackage ./pkgs/kokCursor.nix {};
      npins = callPackage ./pkgs/npins.nix {};
      stash = callPackage (sources.stash + "/nix/package.nix") {};

      # package sets
      lanzaboote = callPackage ./pkgs/lanzaboote {};
      scripts = callPackage ./pkgs/scripts {};
      xvim = callPackage ./pkgs/nvim {};
      booru-images = callPackage ./pkgs/booru-images.nix {};

      # temp
      mbake = pkgs.mbake.overrideAttrs (_prev: {src = sources.bake;});
      # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
      # I had ditched the nixvim project long long long ago but the name just stuck
      nixvim-minimal = warn "Zahpkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self'.xvim.minimal;
      nixvim = warn "Zahpkiel: `nixvim` depricated please use xvim.default instead" self'.xvim.default;
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
