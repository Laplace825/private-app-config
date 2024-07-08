-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb
lvim.transparent_window = true
lvim.builtin.lualine.options.theme = "onedark"
lvim.colorscheme = "tokyonight-moon"
vim.opt.guifont = "FiraCode Nerd Font:h16"
vim.opt.tabstop = 4
lvim.format_on_save = true
vim.keymap.set({ "n", "v" }, "<M-v>", ":vsplit<cr>")
vim.keymap.set({ "n", "v" }, "<M-h>", ":split<cr>")
vim.keymap.set({ "n", "v" }, "<M-c>", ":clos<cr>")
lvim.keys.normal_mode["<leader>rr"] = ":RustRun<CR>"
lvim.keys.normal_mode["<leader>rd"] = ":RustDebuggables<CR>"
lvim.keys.normal_mode["<leader>tf"] = ":TodoLocList<CR>"
vim.opt.tabstop = 4
lvim.keys.normal_mode["<leader>tt"] = ":BufferLinePick<CR>"
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.keymap.set({ "n", "v" }, "<Space>ml", function()
    require("noice").cmd("last")
end)
vim.keymap.set({ "n", "v", }, "<Space>ma", function()
    require("noice").cmd("all")
end)
vim.keymap.set("n", "<F10>", function()
    require 'dap'.step_into()
end)
vim.keymap.set("n", "<F5>", function()
    require 'dap'.step_over()
end)
lvim.builtin.indentlines.active = true

vim.api.nvim_create_autocmd({ "filetype" }, {
    pattern = { "c", "cpp", "md", "txt", "c.snippets", "cpp.snippets" },
    callback = function()
        vim.b.autoformat = true
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
})

-- vim.api.nvim_create_autocmd("bufwritepre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })

-- vim.api.nvim_create_user_command("format", function(args)
--     local range = nil
--     if args.count ~= -1 then
--         local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
--         range = {
--             start = { args.line1, 0 },
--             ["end"] = { args.line2, end_line:len() },
--         }
--     end
--     require("conform").format({ async = true, lsp_fallback = true, range = range })
-- end, { range = true })

lvim.plugins = {
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                ["c"] = { "clang_format" },
                ["cpp"] = { "clang_format" },
                ["c++"] = { "clang_format" },
            },
            formatters = {
                --clang-format = {
                -- prepend_args = {"-style=google"},
                --},
            },
        },
    },
    {
        "simrat39/rust-tools.nvim",
        config = function()
            local status_ok, rust_tools = pcall(require, "rust-tools")
            if not status_ok then
                return
            end

            local opts = {
                tools = {
                    -- executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
                    reload_workspace_from_cargo_toml = true,
                    inlay_hints = {
                        auto = true,
                        only_current_line = false,
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<-",
                        other_hints_prefix = "=>",
                        max_len_align = false,
                        max_len_align_padding = 1,
                        right_align = false,
                        right_align_padding = 7,
                        highlight = "Comment",
                    },
                    hover_actions = {
                        border = {
                            { "╭", "FloatBorder" },
                            { "─", "FloatBorder" },
                            { "╮", "FloatBorder" },
                            { "│", "FloatBorder" },
                            { "╯", "FloatBorder" },
                            { "─", "FloatBorder" },
                            { "╰", "FloatBorder" },
                            { "│", "FloatBorder" },
                        },
                        auto_focus = true,
                    },
                },
                server = {
                    on_attach = require("lvim.lsp").common_on_attach,
                    on_init = require("lvim.lsp").common_on_init,
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy"
                            }
                        }
                    },
                },
            }
            local extension_path = vim.fn.expand "~/" .. ".local/share/nvim/mason/packages/"

            local codelldb_path = extension_path .. "codelldb/extension/adapter/codelldb"
            local liblldb_path = extension_path .. "codelldb/extension/lldb/lib/liblldb.so"

            opts.dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            }
            rust_tools.setup(opts)
        end,
        ft = { "rust", "rs" },
    },
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = 'cool',
                toggle_style_list = { "dark", 'darker', 'cool', 'deep' }
            })
        end
    },
    {
        "GCBallesteros/jupytext.nvim",
        config = true,
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
        'linux-cultist/venv-selector.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        config = function()
            require('venv-selector').setup {
                -- Your options go here
                -- name = "venv",
                auto_refresh = true,
                anaconda_base_path = "/home/lap/anaconda3",
                anaconda_envs_path = "/home/lap/anaconda3/envs",
            }
        end,
        event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        keys = {
            -- Keymap to open VenvSelector to pick a venv.
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
        },
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
                    alt = { "note" },
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
                        size = { width = 0.7, height = 0.3 },
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
                        size = { width = 0.7, height = 0.3 },
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
                "<leader>td",
                "<cmd>Trouble preview_float filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>ts",
                "<cmd>Trouble symbol_float<cr>",
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
        },
    }
}


--透明度
vim.g.neovide_transparency = 0.9
-- cursor特效
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_density = 50.0
vim.g.neovide_cursor_vfx_particle_phase = 1.5
vim.g.neovide_cursor_vfx_mode = "ripple"

-- 抗锯齿
vim.g.neovide_cursor_antialiasing = true
