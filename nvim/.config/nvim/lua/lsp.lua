-- Load comments file
require 'comments'

vim.opt.completeopt = "menu,menuone,noinsert"

vim.diagnostic.config({
    underline = false,
    virtual_text = true, -- Turn off inline diagnostics
    float = {
      border = {
          {"╔", "FloatBorder"},
          {"═", "FloatBorder"},
          {"╗", "FloatBorder"},
          {"║", "FloatBorder"},
          {"╝", "FloatBorder"},
          {"═", "FloatBorder"},
          {"╚", "FloatBorder"},
          {"║", "FloatBorder"}
      },
      source = "always",
      update_in_insert = true,
      severity_sort = true,
    },
  })




-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Enable LSP configurations
require 'lspconfig'.hls.setup{}

local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    -- vim.keymap.set('i', '<Leader>i', vim.lsp.buf.completion)
    if client:supports_method('textDocument/formatting') then
      -- Format the current buffer on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          -- vim.lsp.buf.format({bufnr = bufnr, id = client.id})
        end,
      })
    end
end

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client:supports_method('textDocument/implementation') then
--       -- Create a keymap for vim.lsp.buf.implementation
--     end
--     if client:supports_method('textDocument/formatting') then
--       -- Format the current buffer on save
--       vim.api.nvim_create_autocmd('BufWritePre', {
--         buffer = args.buf,
--         callback = function()
--           vim.lsp.buf.format({bufnr = args.buf, id = client.id})
--         end,
--       })
--     end
--   end,
-- })


local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP Keymaps
require 'lspconfig'.clangd.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
}


require('lspconfig').ruff.setup {}
require 'lspconfig'.pyright.setup{}

util = require 'lspconfig/util'

require 'lspconfig'.gopls.setup{
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        }, },
}

require 'lspconfig'.nil_ls.setup {
    autostart = true,
}

-- require 'lspconfig'.ts_ls.setup{}

require('lspconfig')['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy";
            },
            diagnostics = {
                enable = true;
            }
        }
    }
}

require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "devicetree", "rust" },
    sync_install = true,
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
}

vim.treesitter.language.register('devicetree', 'overlay')

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

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
  },
  use_default_keymaps = false,
})

require("toggleterm").setup({
})
