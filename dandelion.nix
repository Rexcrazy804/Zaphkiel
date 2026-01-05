inputs:
assert inputs ? nixpkgs; let
  inherit (inputs.nixpkgs.lib) flip flatten hasSuffix filter filesystem pipe recursiveUpdate foldAttrs;

  # simply import ALL nix files in a directory
  recursiveImport = path: filter (hasSuffix ".nix") (filesystem.listFilesRecursive path);

  # WARN I DO NOT ENCOURAGE THE USE OF THIS FUNCTION!!!!
  #
  # be a normal person and use flake-parts or something similiar,
  # you have been warned, follow this advice to keep your sanity.
  #
  # Use of this function will lead to error messages that don't
  # inform you of **which** file the error occurs.
  # Hence its down to you to figure that part out
  #
  # Now if you are insane like me,
  # and want to NOT use flake-parts (or reinvent it)
  # are comfortable diggin through trace to figure out what went wrong
  # when things go wrong, feel free to use this
  #
  # Any recommendations / suggestions
  # for improving this function are VERY WELCOME!
  #
  # NOTE an understanding of `recursiveUpdate`
  # and the limitations it imposes is highly recommended
  #
  # $ cat modules/**/**.nix | grep "dandelion.modules.* = " | sort | uniq -d
  # quick sanity check, don't try to have duplicated dandelion.<namespace>.<entry>
  # well you CAN but if one is a funciton and the other isn't, welp won't work.
  # I will cook up something later to do this within the funciton
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
