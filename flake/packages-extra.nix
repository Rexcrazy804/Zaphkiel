{
  self,
  mnw,
  stash,
  hjem,
  ...
}: {
  packages = self.lib.eachSystem ({
    pkgs,
    system,
    pkgx,
  }: {
    xvim = pkgs.callPackage (self.paths.specials + /xvim) {
      inherit (pkgx) sources;
      mnw = mnw.lib;
    };
    hjem-cli = hjem.packages.${system}.hjem;
    stash = let
      stp = stash.packages.${system}.default;
    in
      pkgs.symlinkJoin {
        inherit (stp) meta version pname;
        paths = [stp];
        postBuild = ''
          rm $out/bin/wl-copy
          rm $out/bin/wl-paste
        '';
      };

    equibop = pkgs.equibop;
    # equibop = (pkgs.equibop.overrideAttrs
    #   (self: old: {
    #     version = "3.2.2";
    #     src = old.src.overrideAttrs (_: {hash = "sha256-foKgtyN1jr4+PHwJHTVXrYzWNVYtR1Sq8rLG4VEnujs=";});
    #     node-modules = (
    #       old.node-modules.overrideAttrs
    #       (_: {outputHash = "sha256-TKFL47b+Xh8ChlSyXdhRY+zmPAnkHJss2vNblBvOSmw=";})
    #     ).override {equibop = self;}; # this won't be required for overriding once https://github.com/NixOS/nixpkgs/pull/550390 is merged
    #   })).override {electron_41 = pkgs.electron_43;};
  });
}
