{nixpkgs ? throw "[Dandelion]: passed attribute set must contain nixpkgs!!!", ...} @ inputs: let
  inherit (nixpkgs.lib) flip flatten hasSuffix filter filesystem pipe recursiveUpdate foldAttrs;

  # simply import ALL nix files in a directory
  recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

  # WARN
  # Don't try to have duplicated dandelion.<namespace>.<entry>
  # You have been warned.
  #
  # Use the blow as a quick sanity check
  # $ cat modules/**/**.nix | grep "dandelion.modules.* = " | sort | uniq -d
  #
  # NOTE
  # Now if you want to still use diplicated namespaces
  # an understanding of `recursiveUpdate` is HIGHLY recomended.
  # Just know that it can't merge functions.
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
    (foldAttrs recursiveUpdate {})
  ];
in {
  inherit recursiveImport importModules;
}
