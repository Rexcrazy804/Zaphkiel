{
  # I might have just made reading my flake a hellscape
  # Presenting, the dandruff setup
  description = "Rexiel Scarlet's Flake";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) filter hasSuffix filesystem pipe map flatten flip;
    inherit (nixpkgs.lib) foldAttrs recursiveUpdate callPackageWith;

    recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

    importApply = (flip pipe) [
      flatten
      (map (x:
        if builtins.isPath x
        then import x
        else x))
      (map (x:
        if builtins.isFunction x
        then x inputs
        else x))
      (foldAttrs recursiveUpdate {})
    ];
  in
    importApply [
      (recursiveImport ./modules)
      {
        packages = self.lib.eachSystem ({
          pkgs,
          system,
        }:
          filesystem.packagesFromDirectoryRecursive {
            callPackage = callPackageWith (pkgs // self.packages.${system});
            directory = ./pkgs;
          });
      }
    ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    crane.url = "github:ipetkov/crane";
    mnw.url = "github:Gerg-L/mnw";
    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "";
      inputs.hjem.follows = "";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.smfh.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    booru-hs = {
      url = "github:Rexcrazy804/booru.hs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    stash = {
      url = "github:notashelf/stash/notashelf/push-rnnzunzyvynn";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "";
      inputs.systems.follows = "systems";
    };
    hs-todo = {
      url = "github:Rexcrazy804/haskell-todo";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
  };
}
