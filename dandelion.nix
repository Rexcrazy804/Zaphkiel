{nixpkgs ? throw "[Dandelion]: passed attribute set must contain nixpkgs!!!", ...} @ inputs: let
  inherit (nixpkgs.lib) flip flatten hasSuffix filter filesystem pipe;

  # simply import ALL nix files in a directory
  recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);
  recursiveMerge = import ./specials/lladios-merge-attrs-recursive.nix;

  # NOTE
  # uses recursiveMerge used by lladios
  # should work just fineTM hopefully
  # resolves the issue of function merging errors
  # going unnoticed
  importModules = flip pipe [
    flatten
    (map (x:
      if builtins.isPath x
      then import x
      else x))
    (map (x:
      if builtins.isFunction x
      then x inputs
      else x))
    (x: recursiveMerge {mutators = x;})
  ];
in {
  inherit recursiveImport importModules;
}
