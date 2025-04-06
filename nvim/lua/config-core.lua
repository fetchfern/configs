local vsnip_anonymous = vim.fn["vsnip#anonymous"]
local gitsigns = require("gitsigns")
local treesitter_configs = require("nvim-treesitter.configs")
local lspconfig = require("lspconfig")
local trouble = require("trouble")
local whichkey = require("which-key")
local actions_preview = require("actions-preview")
local luau_lsp = require("luau-lsp")
local cmdbar_cfg = require("cmdbar-cfg")
local nvim_autopairs = require("nvim-autopairs")

local function arrayExtend(target, extension)
    local n = #target
    for i, v in ipairs(extension) do
        target[i + n] = v
    end
end

-- luau-lsp

luau_lsp.setup({
    sourcemap = {
        enabled = true,
        autogenerate = true, -- automatic generation when the server is attached
        rojo_project_file = "default.project.json"
    },
    types = {
        roblox = true,
        roblox_security_level = "PluginSecurity",
    },
})

-- diagnostics

vim.diagnostic.config({
    virtual_text = {
        severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
    },
    signs = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
})

-- actions-preview

actions_preview.setup({
  -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
    diff = {
        ctxlen = 3,
    },

  -- priority list of external command to highlight diff
  -- disabled by default, must be set by yourself
    highlight_command = {
        -- require("actions-preview.highlight").delta(),
        -- require("actions-preview.highlight").diff_so_fancy(),
        -- require("actions-preview.highlight").diff_highlight(),
    },

    -- priority list of preferred backend
    backend = { "telescope", "nui" },

    -- options related to telescope.nvim
    telescope = vim.tbl_extend(
        "force",
        -- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
        require("telescope.themes").get_dropdown(),
        -- a table for customizing content
        {
          -- a function to make a table containing the values to be displayed.
          -- fun(action: Action): { title: string, client_name: string|nil }
          make_value = nil,

          -- a function to make a function to be used in `display` of a entry.
          -- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
          -- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
          make_make_display = nil,
        }
  ),
})

-- which-key

whichkey.setup({})

-- trouble

trouble.setup({
    fold_open = "",
    fold_closed = "",
    icons = {},
    cycle_results = false,
    indent_lines = false,
    signs = {
        error = "E",
        warning = "W",
        hint = "!",
        information = "I",
        other = "?",
    },
})

-- treesitter

treesitter_configs.setup({
  ensure_installed = {
      "c",
      "cpp",
      "lua",
      "vim", 
      "vimdoc",
      "query",
      "rust",
      "markdown",
      "glsl",
      "luau",
  },

  sync_install = true,
  auto_install = false,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
      enable = true,
  }
})

-- tabby


-- gitsigns

gitsigns.setup({
    signcolumn = false,
    numhl = true,
})

-- nvim-cmp
--[[

local CMP_ICON_MAP = {
    nvim_lsp = "%",
    vsnip = "&",
}

cmp.setup({
    snippet = {
        expand = function(args)
            vsnip_anonymous(args.body)
        end,
    },

    preselect = cmp.PreselectMode.None,

    mapping = {
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-k>'] = cmp.mapping.complete(),
    },

    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vsnip' },
        { name = 'codeium' },
    },

    sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.kind,
		},
	},

    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },

    completion = {
        completeopt = "menu,noinsert,noselect",
        keyword_length = 0,
    },

    formatting = {
        format = function(entry, item)
            item.menu = CMP_ICON_MAP[entry.source.name]
            return item
        end,
    },
})

-- rustacean.nvim

vim.g.rustaceanvim = {
    tools = {
    },
    server = {
        on_attach = function(client, bufnr)
            local function set_keymap(binding, action)
                vim.keymap.set("n", binding, function() vim.cmd.RustLsp(action) end, { silent = true, buffer = bufnr })
            end

            --set_keymap("<leader>a", { "hover", "actions" })
        end,
        default_settings = {
            ['rust-analyzer'] = {
                checkOnSave = true,
                check = {
                    command = "clippy",
                },
                cargo = {
                    features = "all",
                },
            },
        },
    },
    dap = {
    },
}
]]
-- lsp

--lspconfig.clandg.setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

local function apply_capabilities(capabilities)
    local language_servers = lspconfig.util.available_servers()

    for _, name in ipairs(language_servers) do
        local server = lspconfig[name]
        server.setup({ capabilities = capabilities })
    end
end

apply_capabilities(capabilities)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- delay update diagnostics
        update_in_insert = true,
    }
)

-- nvim-autopairs

nvim_autopairs.setup({ map_bs = false, map_cr = false })
vim.g.coq_settings = { keymap = { recommended = false }, auto_start = true }

vim.api.nvim_set_keymap('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return nvim_autopairs.esc('<c-y>')
    else
      return nvim_autopairs.esc('<c-e>') .. nvim_autopairs.autopairs_cr()
    end
  else
    return nvim_autopairs.autopairs_cr()
  end
end
vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return nvim_autopairs.esc('<c-e>') .. nvim_autopairs.autopairs_bs()
  else
    return nvim_autopairs.autopairs_bs()
  end
end
vim.api.nvim_set_keymap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

