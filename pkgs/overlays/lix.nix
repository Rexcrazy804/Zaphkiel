# Copyright (c) 2020-2021 Eelco Dolstra and the flake-compat contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
{
  lix,
  versionSuffix ? "",
}: final: prev: let
  lixPackageFromSource = final.callPackage (lix + "/package.nix") {
    inherit versionSuffix;
    stdenv = final.clangStdenv;
  };

  # These packages should receive CppNix since they may link to it or otherwise
  # cause problems (or even just silly mass-rebuilds) if we give them Lix
  overridelist_upstream = [
    "npins"
    "nil"
    "attic-client"
    "devenv"
    "nix-du"
    "nix-init"
    "nix-prefetch-git"
    "nixd"
    "nixos-option"
    "nixt"
    "nurl"
    "prefetch-yarn-deps" # force these onto upstream so we are not regularly rebuilding electron
  ];

  inherit (prev) lib;

  csi = builtins.fromJSON ''"\u001b"'';
  orange = "${csi}[35;1m";
  normal = "${csi}[0m";
  warning = ''
    ${orange}warning${normal}: You have the lix overlay included into a nixpkgs import twice,
    perhaps due to the NixOS module being included twice, or because of using
    pkgs.nixos and also including it in imports, or perhaps some unknown
    machinations of a complicated flake library.
    This is completely harmless since we have no-op'd the second one if you are
    seeing this message, but it would be a small style improvement to fix
    it :)
    P.S. If you had some hack to fix nixos-option build failures in your
    configuration, that was caused by including an older version of the lix
    overlay twice, which is now mitigated if you see this message, so you can
    delete that.
    P.P.S. This Lix has super catgirl powers.
  '';
  wrongMajorWarning = ''
    ${orange}warning${normal}: This Lix NixOS module is being built against a Lix with a
    major version (got ${lixPackageToUse.version}) other than the one the
    module was designed for (expecting ${supportedLixMajor}). Some downstream
    packages like nix-eval-jobs may be broken by this. Consider using a
    matching version of the Lix NixOS module to the version of Lix you are
    using.
  '';

  maybeWarnDuplicate = x:
    if final.lix-overlay-present > 1
    then builtins.trace warning x
    else x;

  versionJson.version = "2.93.2";
  supportedLixMajor = lib.versions.majorMinor versionJson.version;
  lixAttrName = "lix_${lib.versions.major supportedLixMajor}_${lib.versions.minor supportedLixMajor}";
  # We have to use the specific Lix version corresponding to the module and not
  # just pkgs.lix, since it can be that we aren't allowed to upgrade pkgs.lix
  # to an "incompatible" one in the same NixOS stable release.
  #
  # If it's not available, I guess just do pkgs.lix.
  # FIXME: does this cause problems in support channels?
  lixPackageToUse =
    if lix != null
    then lixPackageFromSource
    else (prev.lixPackageSets.latest.lix or prev.lix);

  # Especially if using Lix from nixpkgs, it is plausible that the overlay
  # could be used against the wrong Lix major version and cause confusing build
  # errors. This is a simple safeguard to put in at least something that might be seen.
  maybeWarnWrongMajor = x:
    if !(lib.hasPrefix supportedLixMajor lixPackageToUse.version)
    then builtins.trace wrongMajorWarning x
    else x;

  # It is not enough to *just* throw whatever the default nix version is at
  # anything in the "don't give lix" list, we have to *also* ensure that we
  # give whatever upstream version as specified in the callPackage invocation.
  #
  # Unfortunately I don't think there is any actual way to directly query that,
  # so we instead do something extremely evil and guess which version it
  # probably was. This code is not generalizable to arbitrary derivations, so
  # it will hopefully not make us cry, at least.
  useCppNixOverlay = lib.genAttrs overridelist_upstream (
    name:
      if (lib.functionArgs prev.${name}.override ? "nix")
      then let
        # Get the two common inputs of a derivation/package.
        inputs = prev.${name}.buildInputs ++ prev.${name}.nativeBuildInputs;
        nixDependency =
          lib.findFirst
          (drv: (drv.pname or "") == "nix")
          final.nixVersions.stable_upstream # default to stable nix if nix is not an input
          
          inputs;
        nixMajor = lib.versions.major (nixDependency.version or "");
        nixMinor = lib.versions.minor (nixDependency.version or "");
        nixAttr = "nix_${nixMajor}_${nixMinor}";
        finalNix = final.nixVersions.${nixAttr};
      in
        prev.${name}.override {
          nix = finalNix;
        }
      else prev.${name}
  );

  overlay =
    useCppNixOverlay
    // {
      lix-overlay-present = 1;

      lix = maybeWarnWrongMajor (maybeWarnDuplicate lixPackageToUse);

      nixForLinking = final.nixVersions.stable_upstream; # make sure that nixVersions.stable isn't messed with.

      nixVersions =
        prev.nixVersions
        // {
          stable = final.lix;
          stable_upstream = prev.nixVersions.stable;
        };

      nix-eval-jobs =
        (prev.callPackage (lix + "/subprojects/nix-eval-jobs/default.nix") {
          # lix
          nix = final.lix;
        }).overrideAttrs (
          old: {
            version = "2.93.0-lix-${builtins.substring 0 7 lix.rev}";
            __intentionallyOverridingVersion = true;

            mesonBuildType = "debugoptimized";

            ninjaFlags = old.ninjaFlags or [] ++ ["-v"];
          }
        );

      nix-doc = prev.nix-doc.override {withPlugin = false;};
    };
in
  # Make the overlay idempotent, since flakes passing nixos modules around by
  # value and many other things make it way too easy to include the overlay
  # twice
  if (prev ? lix-overlay-present)
  then {lix-overlay-present = 2;}
  else overlay
