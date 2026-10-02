# TODO
{
  mnw,
  pkgs,
  callPackage,
  lib,
  sources,
}:
lib.fix (self: {
  vimPlugins = callPackage ./plugins.nix {inherit sources;};
  default = mnw.wrap (pkgs // {inherit (self) vimPlugins;}) ./maximal.nix;
  minimal = mnw.wrap pkgs ./minimal.nix;
  vivi = self.default.override (prev: {
    initLua =
      prev.initLua
      + ''
        vim.cmd.colorscheme "tokyonight-night"
      '';
  });
})
