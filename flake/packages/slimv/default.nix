{
  vim-full,
  vimPlugins,
}:
vim-full.customize {
  name = "vim";
  vimrcConfig.customRC = ''
    colorscheme catppuccin
  '';
  vimrcConfig.packages.myplugins = {
    start = [vimPlugins.vim-nix vimPlugins.slimv];
  };
}
