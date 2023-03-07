-- Remap leader to space
vim.g.mapleader = " "

-- Sane defaults
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Buffer positions
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Display invisible characters
vim.opt.list = true
vim.opt.listchars:append({eol = '¬', trail = '⋅', extends = '❯', precedes = '❮'})

-- Set relative line number
vim.opt.relativenumber = true

-- Map the buffer browsing
vim.api.nvim_set_keymap('n', '<C-n>', ':bnext<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-p>', ':bprev<CR>', { noremap = true})

vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })

-- Makes s act like d except it doesn't save the cut text to a register
vim.api.nvim_set_keymap('n', 's', '"_d', { noremap = true })

-- Fzf related commands
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {})

-- Delete the buffer
vim.api.nvim_set_keymap('n', '<leader>x', ':bd<CR>', {})

-- Silver Searcher relative stuff
vim.api.nvim_set_keymap('n', 'K', ':Ag <C-R><C-W><CR>', { noremap = true })

-- Jump to tags
vim.api.nvim_set_keymap('n', '<Space><Space>', '<Esc>/<++><CR><Esc>cf>', {})

-- Save current line as gdb breakpoint
vim.api.nvim_set_keymap('n', '<leader>gdb', ':let @+ = "b " . expand("%") . ":" . line(".")<cr>', {})

-- Global tags
vim.api.nvim_set_keymap('n', '<Leader>gd', ':Gtags <C-R>=expand("<cword>")<CR><CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gr', ':Gtags -r <C-R>=expand("<cword>")<CR><CR>', {})

-- Clear whitespace
vim.api.nvim_set_keymap('n', '<Leader>ws', ':StripWhitespace<cr>', {})

-- Autoresize windows
local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })

vim.api.nvim_create_autocmd(
    'VimResized',
    {
        group = wr_group,
        pattern = '*',
        command = 'wincmd =',
        desc = 'Automatically resize windows when the host window size changes.'
    }
)

-- Run black on save
local on_save_group = vim.api.nvim_create_augroup('OnSave', { clear = true })
vim.api.nvim_create_autocmd(
    'BufWritePre',
    {
        group = on_save_group,
        pattern = '*.py',
        command = 'Black',
        desc = 'Run black on saving a python file',
    }
)
