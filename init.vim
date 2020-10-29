scriptencoding utf-8
set termguicolors
augroup start_screen
  au!
  autocmd VimEnter * ++once lua require('init')
augroup END
