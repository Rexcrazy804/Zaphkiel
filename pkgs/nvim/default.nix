{
  sources,
  pkgs,
  newScope,
  lib,
}:
lib.makeScope newScope (self: {
  vimPlugins' = self.callPackage ./plugins.nix {inherit sources;};
  wrapper = self.callPackage ./wrapper.nix {inherit (sources) mnw;};
  minimal = import ./config.nix {
    inherit (self) wrapper;
    inherit pkgs;
    vimPlugins = self.vimPlugins';
  };
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
        vim.cmd.colorscheme "dracula"
      '';
  });
})
