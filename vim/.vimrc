call plug#begin()
" # Syntax / Language Support ##########################
Plug 'tbastos/vim-lua'
Plug 'LnL7/vim-nix'
Plug 'rust-lang/rust.vim'
" For markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" # UI #################################################
Plug 'scrooloose/syntastic'
Plug 'ayu-theme/ayu-vim' " or other package manager
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'christoomey/vim-tmux-navigator'

" # Editor Features ####################################
if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
Plug 'preservim/nerdtree'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-unimpaired'
Plug 'm-pilia/vim-ccls'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-easy-align'
Plug 'ntpeters/vim-better-whitespace'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" # Buffer / Pane / File Management ####################
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" # Panes / Larger features ############################
Plug 'tpope/vim-fugitive'
call plug#end()

" UI
set termguicolors
let ayucolor="dark"
colorscheme ayu

" Highlight c and cpp
let g:cpp_member_variable_highlight=1
let g:cpp_posix_standard=1
let g:cpp_class_decl_highlight=1
let g:cpp_experimental_template_highlight=1

set relativenumber
syntax enable
filetype plugin on

:set hlsearch
:set hidden

" Allows per project vimrc
set exrc

" Fastens the escape sequence
" set esckeys
" Do not redraw screen in the middle of the macros, makes them complete faster
set lazyredraw
" With both on, searches with no capitals are case insensitive, while searches with a capital characters are case sensitive.
set smartcase
" Shows in realtime what the ex command is going to do, only in nvim
" set inccommand=nosplit

set expandtab
" Uses shiftwidth instead of tabstops at start of lines
set smartindent
set smarttab
" " show existing tab with 4 spaces width
set tabstop=4
set softtabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4

" line limits
set cc=150
highlight ColorColumn ctermbg=4

" toggle invisible characters
set invlist
set list
set listchars=tab:¦\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap Q <nop>
" Makes s act like d except it doesn't save the cut text to a register
nnoremap s "_d

map <leader>mk :!make all && make flash
map <leader>ws :StripWhitespace<cr>
map =j :%!python -m json.tool<CR>
map <leader>f :Files<cr>
map <leader>b :Buffers<cr>
" Save all and run make
map <leader>m :wa<cr> :make<cr>
" Delete the buffer
map <leader>x :bd<cr>
" Open cwindow
map <Leader>w :cwindow<CR>
map <Leader>x :BD<CR>

" Replace word under cursor with leader-s
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Shortcut for ctags
" Open up the current tag in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Highlight the right buffer when switching buffers
" autocmd BufWinEnter * NERDTreeFind

let g:TerminusFocusReporting=0

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

autocmd FileType typescript setlocal shiftwidth=2 softtabstop=2  tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2  tabstop=2

" Change the autocompletion menu
highlight Pmenu ctermbg=blue guibg=blue

set completeopt-=preview

" Silver Searcher relative stuff
nnoremap K :Ag <C-R><C-W><CR>

" Resize panes when window/terminal gets resize
autocmd VimResized * :wincmd =

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

set tags=./tags;/

" This section is used only for the geodude related C projects
map <Space><Space> <Esc>/<++><CR><Esc>cf>
command GenDoc :r $HOME/.vim/resources/c_documentation.txt
command GenFunc :r $HOME/.vim/resources/c_function.txt
command GenSource :r $HOME/.vim/resources/c_source.txt
command GenHeader :r $HOME/.vim/resources/c_header.txt


" Coc.nvim
" caller
map <Leader>c :call CocLocations('ccls','$ccls/call')<cr>
" callee
map <Leader>C :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>
let g:ccls_log_file = expand('~/my_log_file.txt')


" Remap TAB and shift tab to select completion candidate
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" To be used with gdb, create a breakpoint from the current file and line
nmap <leader>gdb :let @+ = "b " . expand("%") . ":" . line(".")<cr>

" Disable unsafe commands in project specific vimrc
set secure

