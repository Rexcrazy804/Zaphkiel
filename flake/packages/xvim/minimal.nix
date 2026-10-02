{pkgs, ...}: {
  neovim = pkgs.neovim-unwrapped;
  providers.python3.enable = true;
  initLua = ''
    require("config")
    vim.cmd.colorscheme "catppuccin"
  '';

  plugins.dev.myconfig = {
    pure = ../../../dots/nvim;
    impure = "/home/rexies/nixos/dots/nvim";
  };
}
