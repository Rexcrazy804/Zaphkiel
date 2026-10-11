{pkgs, ...}: {
  neovim = pkgs.neovim-unwrapped;
  providers.python3.enable = true;
  initLua = ''
    require("config")
    require("native")
  '';

  plugins.dev.myconfig = {
    pure = ../../../dots/nvim;
    impure = "/home/rexies/nixos/dots/nvim";
  };
}
