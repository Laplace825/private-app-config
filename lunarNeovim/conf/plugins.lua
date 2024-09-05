lvim.plugins = {
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        keys = {
            { "<Space>vs", "<cmd>VenvSelect<cr>" },
        },
    },
    {
        -- @note: should TSInstall html
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",

            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust", "rs" },
        config = function()
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["c"] = { "clang_format" },
                ["cpp"] = { "clang_format" },
                ["c++"] = { "clang_format" },
                ["python"] = { "black" },
            },
            formatters = {
                --clang-format = {
                -- prepend_args = {"-style=google"},
                --},
            },
        },
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        -- if you need to install/update all binaries
        build = ':lua require("go.install").update_all_sync()'
    },
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "deep",
                -- transparent = true,
                lualine = {
                    transparent = true,
                },
                term_colors = true,
            })
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "Mofiqul/dracula.nvim",
    },
    {
        "github/copilot.vim",
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            sign_priority = 3,
            keywords = {
                PERF = {
                    alt = { "pefr", "param", "return", "PARAM" },
                },
                FIX = {
                    alt = { "FIXME", "BUG", "fix" },
                },
                TODO = {
                    alt = { "todo" },
                },
                WARN = {
                    alt = { "warn" },
                },
                NOTE = {
                    alt = { "note", "brief", "example", "file" },
                },
                TEST = {
                    icon = "𐰬",
                    alt = { "test" },
                },
            },
            highlight = {
                keyword = "wide_fg",
                after = "",
            }
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
                messages = {
                    view = "split",
                }
            },


        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
    {
        "folke/trouble.nvim",
        opts = {
            modes = {
                preview_float = {
                    focus = true,
                    auto_close = true,
                    mode = "diagnostics",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 2, 0.3 },
                        size = { width = 1, height = 0.3 },
                        zindex = 200,
                    },
                },
                symbol_float = {
                    focus = true,
                    auto_close = true,
                    mode = "symbols",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 2, 0.3 },
                        size = { width = 0.5, height = 0.3 },
                        zindex = 200,
                    },
                },

                todo_float = {
                    focus = true,
                    auto_close = true,
                    mode = "todo",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 2, 0.3 },
                        size = { width = 1, height = 0.3 },
                        zindex = 200,
                    },
                },
                lsp_toggle_float = {
                    focus = true,
                    auto_close = true,
                    mode = "lsp",
                    preview = {
                        type = "float",
                        relative = "editor",
                        border = "rounded",
                        title = "Preview",
                        title_pos = "center",
                        position = { 2, 0.3 },
                        size = { width = 0.5, height = 0.3 },
                        zindex = 200,
                    },
                }
            },
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>ta",
                "<cmd>Trouble preview_float<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>tp",
                "<cmd>Trouble preview_float filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            }, {
            "<leader>ts",
            "<cmd>Trouble symbol_float<cr>",
            desc = "Symbols (Trouble)",
        },
            {
                "<leader>lt",
                "<cmd>Trouble lsp_toggle_float toggle<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
        },
    }
}

require("markview").setup({
    modes = { "n", "no", "c" }, -- Change these modes
    -- to what you need

    hybrid_modes = { "n" }, -- Uses this feature on
    -- normal mode

    -- This is nice to have
    callbacks = {
        on_enable = function(_, win)
            vim.wo[win].conceallevel = 2;
            vim.wo[win].concealcursor = "c";
        end
    }
})

require("venv-selector").setup {
    settings = {
        search = {
            anaconda_base = {
                command = "fd /python$ /home/lap/miniconda3/bin --full-path --color never -E /proc",
                type = "anaconda"
            },
        },
    },
}

