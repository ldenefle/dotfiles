" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" let g:python3_host_prog = '/usr/bin/python'
" source ~/.vimrc

lua require("plugins")
lua require("editor")
lua require("lsp")

colorscheme ayu
set termguicolors
set mouse=

lua require("statusline")
