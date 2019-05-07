if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'dylanaraps/wal.vim'
" Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'baskerville/vim-sxhkdrc'
Plug 'tbastos/vim-lua'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'zxqfl/tabnine-vim'
call plug#end()

colorscheme wal
set relativenumber
syntax enable
filetype plugin on

:set hlsearch
:set smartindent
:set foldmethod=indent
:set hidden

" Set 4 spaces instead of tab, used for Sevenhugs project
:autocmd BufRead,BufNewFile $COBRAPATH/* setlocal ts=4 sw=4 et

nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap Q <nop>

map <leader>mk :!make all && make flash
map <leader>ws :FixWhitespace<cr>
map =j :%!python -m json.tool<CR>
map <leader>f :Files<cr>
map <leader>b :Buffers<cr>

let g:TerminusFocusReporting=0

" Close the preview tab
let g:ycm_autoclose_preview_window_after_completion = 1

" Avoids folding on GoFmt
" let g:go_fmt_experimental = 1

" Jump to last known line when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

set statusline=%t       "tail of the filename
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%-10.3n "buffer number
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
" first, enable status line always
set laststatus=2

hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
" now set it up to change the status line based on mode
if version >= 700
  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
endif
