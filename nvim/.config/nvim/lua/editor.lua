-- Remap leader to space
vim.g.mapleader = " "

-- Sane defaults
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

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

-- Open file navigator
vim.api.nvim_set_keymap('n', '<Leader>nt', ':NvimTreeToggle<cr>', {})
vim.api.nvim_set_keymap('n', '<Leader>o', ':Oil<cr>', {})

vim.keymap.set('n', '<Leader>d', function()
    vim.diagnostic.open_float()
end, { remap = true})

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
-- vim.api.nvim_create_autocmd(
--     'BufWritePre',
--     {
--         group = on_save_group,
--         pattern = '*.py',
--         command = 'Black',
--         desc = 'Run black on saving a python file',
--     }
-- )


-- Setup template plugin
require('template').setup({
    temp_dir = '~/.config/nvim/templates',
    author = 'Lucas Denefle',
    email = 'ldenefle@gmail.com',
})

vim.keymap.set('n', '<Leader>t', function()
    vim.fn.feedkeys(':Template ')
end, { remap = true})


--[[ Oil configuration ]]
local detail = false

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        -- If there is no current directory (e.g. over ssh), just show the buffer name
        return vim.api.nvim_buf_get_name(0)
    end
end

-- helper function to parse output
local function parse_output(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
        for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub("/$", "")
            ret[line] = true
        end
    end
    return ret
end

-- build git status cache
local function new_git_status()
    return setmetatable({}, {
        __index = function(self, key)
            local ignore_proc = vim.system(
                { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
                {
                    cwd = key,
                    text = true,
                }
            )
            local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
                cwd = key,
                text = true,
            })
            local ret = {
                ignored = parse_output(ignore_proc),
                tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
        end,
    })
end
local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = require("oil.actions").refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
end

-- Toggleterm configuration
require("toggleterm").setup({
})

local Terminal  = require('toggleterm.terminal').Terminal
local tig = Terminal:new({
  cmd = "tig",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _tig_toggle()
  tig:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _tig_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>nn", "<cmd>ToggleTerm direction=float<CR>", {noremap = true, silent = true})

-- Oil configuration
require("oil").setup({
  watch_for_changes = true,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["bd"] = { "actions.close", mode = "n" },
    -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
    -- ["<C-p>"] = "actions.preview",
    -- ["<C-c>"] = { "actions.close", mode = "n" },
    -- ["<C-l>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
    ["gd"] = {
      desc = "Toggle file detail view",
      callback = function()
        detail = not detail
        if detail then
          require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
        else
          require("oil").set_columns({ "icon" })
        end
      end,
    },
  },
  use_default_keymaps = false,
  view_options = {
    is_hidden_file = function(name, bufnr)
      local dir = require("oil").get_current_dir(bufnr)
      local is_dotfile = vim.startswith(name, ".") and name ~= ".."
      -- if no local directory (e.g. for ssh connections), just hide dotfiles
      if not dir then
        return is_dotfile
      end
      -- dotfiles are considered hidden unless tracked
      if is_dotfile then
        return not git_status[dir].tracked[name]
      else
        -- Check if file is gitignored
        return git_status[dir].ignored[name]
      end
    end,
  },
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    -- args.buf is the buffer number for the event
    local ok = pcall(vim.treesitter.start, args.buf)
    -- If no parser exists, start() errors; pcall prevents noise.
    -- ok is unused, but keeping it makes intent clear.
  end,
})
