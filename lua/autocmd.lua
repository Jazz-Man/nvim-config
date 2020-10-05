local a = require "utils/general"

local autocmd = {
  bufs = {
    {"BufWritePost", [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]]}
  },
  yank = {
    {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="YankColor", timeout=400})]]},
    {"ColorScheme", [[* highlight YankColor ctermfg=59 ctermbg=41 guifg=#34495E guibg=#2ECC71]]}
  }
}

a.Create_augroup(autocmd)
