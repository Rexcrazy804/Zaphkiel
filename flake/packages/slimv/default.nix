{
  vim-full,
  vimPlugins,
}:
vim-full.customize {
  name = "vim";
  vimrcConfig.packages.myplugins = {
    start = [vimPlugins.slimv];
  };
}
