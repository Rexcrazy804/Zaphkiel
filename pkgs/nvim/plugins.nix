# extra plugins and plugin overrides (for latest rev)
{
  sources,
  vimPlugins,
  vimUtils,
  lib,
}: let
  inherit (vimUtils) buildVimPlugin;
  inherit (lib) substring;

  toVersion = substring 0 8;
in
  vimPlugins.extend (final': prev': {
    # for future reference
    # flash-nvim = prev'.flash-nvim.overrideAttrs (_old: {
    #   src = (sources."flash.nvim" { pkgs = final; });
    # });

    image-nvim = buildVimPlugin {
      pname = "image.nvim";
      version = "07-09-24";
      src = sources."image.nvim";

      nvimSkipModules = ["minimal-setup"];
    };
    neorg = prev'.neorg.overrideAttrs (_: {
      src = sources.neorg;
      version = toVersion sources.neorg.revision;
    });
  })
