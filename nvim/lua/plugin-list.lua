return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "ms-jpq/coq_nvim", branch = "coq" }
        },
        init = function()
            vim.g.coq_settings = {
                auto_start = true
            }
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module "neo-tree"
        ---@type neotree.Config?
        config = function()
            require("neo-tree").setup({
                close_if_last_window = false,
                filesystem = {
                    use_libuv_file_watcher = true,
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false
                    }
                }
            })
        end
    },
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xw",
                "<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<cr>",
                desc = "Warnings (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    "EdenEast/nightfox.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope.nvim", lazy = false },
    { "mrcjkb/rustaceanvim", tag = "3.14.0" },
    "jbyuki/instant.nvim",
    "kevinhwang91/promise-async",
    "lopi-py/luau-lsp.nvim",
    "mrcjkb/haskell-tools.nvim",
    "kylechui/nvim-surround",
    "folke/which-key.nvim",
    "aznhe21/actions-preview.nvim",
    "lewis6991/gitsigns.nvim",
    "kdheepak/lazygit.nvim",
    "folke/trouble.nvim",
    "nanozuki/tabby.nvim",
    "lurst/austere.vim",
    "zenbones-theme/zenbones.nvim",
    "rktjmp/lush.nvim",
    "ellisonleao/gruvbox.nvim",
    "windwp/nvim-autopairs"
}
