{
  vim-full,
  vimPlugins,
}:
vim-full.customize {
  name = "vim";
  vimrcConfig.customRC = ''
     colorscheme catppuccin

     set wildmode=noselect:lastused,full
     set wildoptions=pum,fuzzy,tagfile

    func FindGitFiles(cmdarg, cmdcomplete)
       let fnames = systemlist('git ls-files')
       return matchfuzzy(fnames, a:cmdarg)
     endfunc

     set findfunc=FindGitFiles
  '';
  vimrcConfig.packages.myplugins = {
    start = [vimPlugins.vim-nix vimPlugins.slimv];
  };
}
