-- Plugin configuration

-- Localvimrc configuration
vim.g.localvimrc_ask = 1
vim.g.localvimrc_whitelist = {'/home/lucas/_CODE/Converge/geodude-hw-app', '/home/lucas/_CODE/Converge/steelix-app-workspace' }
vim.g.localvimrc_sandbox = 0

-- Disable pesky go plugin shortcuts
vim.g.go_doc_keywordprg_enabled = 0

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    -- Syntax / Language Support
    gh('neovim/nvim-lspconfig'),
    gh('hrsh7th/nvim-cmp'),
    gh('hrsh7th/cmp-nvim-lsp'),
    gh('hrsh7th/cmp-vsnip'),
    gh('hrsh7th/vim-vsnip'),
    gh('tbastos/vim-lua'),
    gh('LnL7/vim-nix'),
    gh('rust-lang/rust.vim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('plasticboy/vim-markdown'),
    gh('goldie-lin/vim-dts'),
    gh('vim-python/python-syntax'),
    gh('rhysd/vim-clang-format'),

    -- UI
    gh('Shatur/neovim-ayu'),
    gh('christoomey/vim-tmux-navigator'),
    gh('echasnovski/mini.nvim'),

    -- Editor Features
    gh('Raimondi/delimitMate'),
    gh('p00f/clangd_extensions.nvim'),
    gh('numToStr/Comment.nvim'),
    gh('tpope/vim-surround'),
    gh('tpope/vim-sensible'),
    gh('tpope/vim-repeat'),
    gh('tpope/vim-unimpaired'),
    gh('junegunn/vim-easy-align'),
    gh('ntpeters/vim-better-whitespace'),
    gh('fatih/vim-go'),
    gh('embear/vim-localvimrc'),
    gh('glepnir/template.nvim'),
    gh('nvim-tree/nvim-tree.lua'),
    gh('akinsho/toggleterm.nvim'),

    -- Buffer / Pane / File Management
    gh('junegunn/fzf'),
    gh('junegunn/fzf.vim'),
    gh('stevearc/oil.nvim'),

    -- Git
    gh('tpope/vim-fugitive'),
})
