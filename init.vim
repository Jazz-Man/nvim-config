source $VIMRUNTIME/menu.vim


augroup start_screen
  au!
  autocmd VimEnter * ++once lua require('init')
augroup END
