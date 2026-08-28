# ripped from https://github.com/llakala/lladios/blob/398192b3eb1e1fe66ffd64be8c11aee2f4bb5dac/adios/lib/merge-attrs-recursively.nix
let
  inherit
    (builtins)
    zipAttrsWith
    head
    all
    isAttrs
    length
    ;
  isDerivation = value: (value.type or null) == "derivation";
in
  {mutators}: let
    recurse = zipAttrsWith (
      key: values:
        if length values == 1
        then head values
        else if all (value: isAttrs value && !isDerivation value) values
        then recurse values
        else
          throw ''
            While attempting to merge mutators:
            Found key '${key}' set to multiple values that couldn't be merged.
          ''
    );
  in
    recurse mutators
