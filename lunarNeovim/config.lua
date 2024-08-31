-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.transparent_window = false
-- lvim.builtin.lualine.options.theme = "onedarker"
-- lvim.colorscheme = "onedark"
-- lvim.colorscheme = "tokyonight-moon"

vim.opt.guifont = "FiraCode Nerd Font:h14"
vim.opt.tabstop = 4
vim.opt.fileencoding = "utf-8"
vim.opt.relativenumber = true
lvim.format_on_save = true

require("lspconfig").clangd.setup({
    cmd = { "clangd", "--background-index", "--header-insertion=never" },
    filetypes = { "c", "cpp", "cuda", "proto", "objc", "objcpp" },
    root_dir = require("lspconfig/util").root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".clangd",
        ".clang-tidy", ".clang-format"),
    single_file_support = true,
})

vim.keymap.set({ "n", "v" }, "<M-v>", ":vsplit<cr>")
vim.keymap.set({ "n", "v" }, "<M-h>", ":split<cr>")
vim.keymap.set({ "n", "v" }, "<M-c>", ":close<cr>")
vim.keymap.set({ "n", "v" }, "U", "<c-r>")

-- @note: rust 运行调试
lvim.keys.normal_mode["<TAB>rr"] = ":RustLsp run<CR>"
lvim.keys.normal_mode["<TAB>rd"] = ":RustLsp debuggables<CR>"
lvim.keys.normal_mode["<TAB>rt"] = ":RustLsp testables<CR>"
lvim.keys.normal_mode['<TAB>rl'] = ":RustLsp runnables<CR>"

--@note: go 运行调试
lvim.keys.normal_mode["<TAB>gr"] = ":GoRun<CR>"
lvim.keys.normal_mode["<TAB>gd"] = ":GoDebug<CR>"
lvim.keys.normal_mode["<TAB>gs"] = ":GoStop<CR>"

lvim.keys.normal_mode["<leader>td"] = ":Trouble todo_float<CR>"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.keymap.set({ "n", "v" }, "<Space>nt", function()
    require("noice").cmd("telescope")
end)
vim.keymap.set("n", "<F4>", function()
    require 'dap'.step_into()
end)
vim.keymap.set("n", "<F5>", function()
    require 'dap'.step_over()
end)
lvim.builtin.indentlines.active = true

-- @note: 解决 Tab 的问题
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*',
    callback = function()
        if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
            and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require('luasnip').session.jump_active
        then
            require('luasnip').unlink_current()
        end
    end
})

-- 创建build.nvim 目录
-- 在创建之前判断是否存在，存在则不创建，不存在则创建
vim.api.nvim_create_user_command('CPPRun', function()
    -- 判断当前路径是否存在build目录
    local path = vim.fn.expand('%:p:h') .. '/build'
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, 'p')
    end
    --  进入build目录执行cmake
    vim.cmd('cd ' .. path)
    vim.cmd('!cmake .. -G Ninja')
    vim.cmd('!ninja -j12')

    vim.cmd('!./' .. vim.fn.expand('%:t:r'))
    -- 执行完毕后返回原路径
    vim.cmd('!cd -')
end, {
    desc = { 'Run C++ code',
    },
})

lvim.plugins = {
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
                    alt = { "pefr", "param", "return" },
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
                    alt = { "note", "brief", "example" },
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

-- @note: 这是内置lsp代码hint
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())


-- @note: 需要用mason安装codelldb
local dap = require("dap")
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
    },
}
dap.configurations.c = dap.configurations.cpp

vim.g.rustaceanvim = function()
    -- Update this path
    local extension_path = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension/'
    local codelldb_path = extension_path .. '/adapter/codelldb'
    local liblldb_path = extension_path .. '/lldb/lib/liblldb'

    local cfg = require('rustaceanvim.config')
    return {
        dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
    }
end

lvim.lsp.automatic_servers_installation = false
lvim.lsp.installer.setup.ensure_installed = {
    "html"
}
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
lvim.lsp.installer.setup.automatic_installation = {
    exclude = { "rust_analyzer", "rust-analyzer" }
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

--透明度
vim.g.neovide_transparency = 0.78

-- 非垂直同步 --no-vsync 时的刷新率
vim.g.neovide_refresh_rate = 144
vim.g.neovide_refresh_rate_idle = 3 -- 闲置刷新率
-- vim.g.neovide_profiler = true

-- cursor特效
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_density = 80.0
vim.g.neovide_scale_factor = 1.1
vim.g.neovide_cursor_vfx_particle_phase = 1.5
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_smooth_blink = true

-- 抗锯齿
-- vim.g.neovide_cursor_antialiasing = true
