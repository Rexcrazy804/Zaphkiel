final: prev: {
  discord = prev.vesktop;
  gnomon = final.callPackage ../gnomon.nix {};

  # extra stuff to refer to later

  # I would spank Quinz for telling me about rare
  # and how outdated it was in nixpkgs
  # rare = prev.rare.overrideAttrs (old: {
  #   inherit (sources.rare) version;
  #   src = final.applyPatches {
  #     name = "patched-rare-src";
  #     patches = [../patches/rare.patch];
  #     src = sources.rare {pkgs = final;};
  #   };
  #   propagatedBuildInputs =
  #     old.propagatedBuildInputs
  #     ++ [
  #       final.python3Packages.setuptools-scm
  #       final.python3Packages.vdf
  #       final.python3Packages.pyside6
  #     ];
  # });

  # example to use npins to for nvim plugins
  # vimPlugins = prev.vimPlugins.extend (final': prev': {
  #   flash-nvim = prev'.flash-nvim.overrideAttrs (_old: {
  #     src = (sources."flash.nvim" { pkgs = final; });
  #   });
  # });
}
