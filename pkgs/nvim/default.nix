{
  mnw,
  pkgs,
  callPackage,
  lib,
  sources,
}:
lib.fix (self: {
  vimPlugins = callPackage ./plugins.nix {inherit sources;};
  minimal = mnw.wrap (pkgs // {inherit (self) vimPlugins;}) ./config.nix;
  default = self.minimal.override (prev: {
    extraBinPath =
      prev.extraBinPath
      ++ [
        # language servers
        pkgs.nil
        pkgs.lua-language-server
        pkgs.kdePackages.qtdeclarative
        # formatter
        pkgs.alejandra
      ];
  });
  vivi = self.default.override (prev: {
    initLua =
      prev.initLua
      + ''
        vim.cmd.colorscheme "tokyonight-night"
      '';
  });
})
