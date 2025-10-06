-- Plugin configuration
--

-- Localvimrc configuration
vim.g.localvimrc_ask = 1
vim.g.localvimrc_whitelist = {'/home/lucas/_CODE/Converge/geodude-hw-app', '/home/lucas/_CODE/Converge/steelix-app-workspace' }
vim.g.localvimrc_sandbox = 0

-- Disable pesky go plugin shortcuts
vim.g.go_doc_keywordprg_enabled = 0

return require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

	-- Syntax / Language Support ##########################
    use 'neovim/nvim-lspconfig'        -- Sane LSP configurations
    use 'hrsh7th/nvim-cmp' -- A completion plugin written in lua
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
	use 'tbastos/vim-lua'
	use 'LnL7/vim-nix'
	use 'rust-lang/rust.vim'
    use 'nvim-treesitter/nvim-treesitter'
    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {}
        end,
    }
	-- For markdown
	use 'plasticboy/vim-markdown'
	-- DTS highlighting
	use 'goldie-lin/vim-dts'
	-- Better python highlighting
	use 'vim-python/python-syntax'
	use 'rhysd/vim-clang-format'

	-- UI #################################################
	use 'Shatur/neovim-ayu'
	use 'christoomey/vim-tmux-navigator'
    use 'echasnovski/mini.nvim'

	-- Editor Features ####################################
	use 'Raimondi/delimitMate'
	use 'm-pilia/vim-ccls'
    use 'numToStr/Comment.nvim'
	use 'tpope/vim-surround'
	use 'tpope/vim-sensible'
	use 'tpope/vim-repeat'
	use 'tpope/vim-unimpaired'
	use 'junegunn/vim-easy-align'
	use 'ntpeters/vim-better-whitespace'
	use 'fatih/vim-go'
	use 'embear/vim-localvimrc'
	use 'vim-scripts/gtags.vim'
    use 'glepnir/template.nvim'
    use 'nvim-tree/nvim-tree.lua'
  use 'akinsho/toggleterm.nvim'

	-- Buffer / Pane / File Management ####################
	use { 'junegunn/fzf.vim', commit = 'ec75ffbfd50630bf2b8d444d89487e149bacf7f3' }
	use 'stevearc/oil.nvim'

	--" # Panes / Larger features ############################
	use 'tpope/vim-fugitive'

end)

