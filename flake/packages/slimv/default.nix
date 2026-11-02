{
  vim-full,
  vimPlugins,
}:
vim-full.customize {
  name = "vim";
  vimrcConfig.customRC =
    # vim
    ''
      colorscheme catppuccin

      set wildmode=noselect:lastused,full
      set wildoptions=pum,fuzzy,tagfile

      func FindGitFiles(cmdarg, cmdcomplete)
          let fnames = systemlist('git ls-files')
          return matchfuzzy(fnames, a:cmdarg)
      endfunc

      set findfunc=FindGitFiles

      let g:slimv_repl_split=2
      let g:slimv_repl_split_size=10

      augroup unlist_special_files
        autocmd!
        autocmd BufEnter REPL setlocal nobuflisted
      augroup END

      set dir=~/tmp " don't put swapfiles in my working copy thank you
    '';
  vimrcConfig.packages.myplugins = {
    start = [vimPlugins.vim-nix vimPlugins.slimv];
  };
}
