{
  pkgs,
  lib,
  mnw,
  callPackage,
}: let
  # just taking what I need from mnw, you don't need to do this
  wrapper-uncheckd = callPackage (mnw + "/wrapper.nix") {};
  wrapper = module: let
    evaled = lib.evalModules {
      specialArgs = {
        inherit pkgs;
        modulesPath = mnw + "/modules";
      };
      modules = [
        (import (mnw + "/modules/options.nix") false)
        module
      ];
    };

    failedAssertions = map (x: x.message) (builtins.filter (x: !x.assertion) evaled.config.assertions);
    baseSystemAssertWarn =
      if failedAssertions != []
      then throw "\nFailed assertions:\n${lib.concatMapStrings (x: "- ${x}") failedAssertions}"
      else lib.showWarnings evaled.config.warnings;
  in
    wrapper-uncheckd (baseSystemAssertWarn evaled.config);
in
  wrapper
