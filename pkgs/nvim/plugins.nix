# extra plugins and plugin overrides (for latest rev)
{
  sources,
  vimPlugins,
  vimUtils,
}: let
  inherit (vimUtils) buildVimPlugin;
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
  })
