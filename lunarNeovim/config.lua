-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.transparent_window = false
-- lvim.builtin.lualine.options.theme = "onedarker"
local lualine_config_self = false
lvim.colorscheme = "onedark"
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

--@note: markdown
vim.g.mkdp_echo_preview_url = true
lvim.keys.normal_mode["<leader>mp"] = ":MarkdownPreview<CR>"
lvim.keys.normal_mode["<leader>ms"] = ":MarkdownPreviewStop<CR>"

vim.opt.termguicolors = true

-- vim.api.nvim_create_autocmd({ "filetype" }, {
--     pattern = { "c", "cpp", "md", "txt", "c.snippets", "cpp.snippets" },
--     callback = function()
--         vim.b.autoformat = true
--         vim.opt_local.expandtab = true
--         vim.opt_local.tabstop = 4
--         vim.opt_local.shiftwidth = 4
--         vim.opt_local.softtabstop = 4
--     end,
-- })


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
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust", "rs" },
        config = function()
        end,
    },
    -- install with yarn or npm
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
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
        'linux-cultist/venv-selector.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        config = function()
            require('venv-selector').setup {
                -- Your options go here
                -- name = "venv",
                auto_refresh = true,
                anaconda_base_path = "/home/lap/miniconda3",
                anaconda_envs_path = "/home/lap/miniconda3/envs",
                stay_on_this_version = true,
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
        require("notify").setup({
            background_colour = "#000000",
        }),
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
-- lvim.lsp.installer.setup.automatic_installation = false


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

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
lvim.lsp.installer.setup.automatic_installation = {
    exclude = { "clangd", "rust_analyzer", "rust-analyzer" }
}


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



if lualine_config_self then
    local lineLengthWarning = 60
    local lineLengthError = 120
    lvim.builtin.lualine.sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
    lvim.builtin.lualine.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
    -- }}}2

    -- Colours, maps and icons {{{2
    local colors = {
        bg               = '#0f1117',
        -- bg               = '#3f3f3f',
        modetext         = '#000000',

        giticonbg        = '#ffffff',
        gitbg            = '#7799ff',
        gittext          = '#ffffff',

        diagerror        = '#F44747',
        diagwarning      = '#FF8800',
        diaghint         = '#4FC1FF',
        diaginfo         = '#FFCC66',

        lspiconbg        = '#f4606c',
        lspbg            = '#cccccc',
        lsptext          = '#1a2a3a',

        typeiconbg       = '#a0eee1',
        typebg           = '#1a2a3a',
        typetext         = '#ffffff',
        typeiconbgrw     = '#F8F7F4',
        typetextmodified = '#F8F7F4',
        typeiconbgro     = '#000000',
        typetextreadonly = '#000000',

        statsiconbg      = '#bee7e9',
        statsbg          = '#5080A0',
        statstext        = '#1a2a3a',

        lineokfg         = '#000000',
        lineokbg         = '#5080A0',
        linelongerrorfg  = '#FF0000',
        linelongwarnfg   = '#FFFF00',
        linelongbg       = '#5080A0',

        shortbg          = '#DCDCAA',
        shorttext        = '#000000',

        shortrightbg     = '#3F3F3F',
        shortrighttext   = '#7C4C4E',

        red              = '#D16969',
        yellow           = '#DCDCAA',
        magenta          = '#D16D9E',
        green            = '#608B4E',
        orange           = '#FF8800',
        purple           = '#C586C0',
        blue             = '#569CD6',
        cyan             = '#4EC9B0'
    }

    local mode_map = {
        ['n']        = { '#569CD6', ' NORMAL ' },
        ['i']        = { '#D16969', ' INSERT ' },
        ['R']        = { '#D16969', 'REPLACE ' },
        ['c']        = { '#608B4E', 'COMMAND ' },
        ['v']        = { '#C586C0', ' VISUAL ' },
        ['V']        = { '#C586C0', ' VIS-LN ' },
        ['s']        = { '#FF8800', ' SELECT ' },
        ['S']        = { '#FF8800', ' SEL-LN ' },
        ['t']        = { '#569CD6', 'TERMINAL' },
        ['Rv']       = { '#D16D69', 'VIR-REP ' },
        ['rm']       = { '#FF0000', '- More -' },
        ['r']        = { '#FF0000', "- Hit-Enter -" },
        ['r?']       = { '#FF0000', "- Confirm -" },
        ['cv']       = { '#569CD6', "Vim Ex Mode" },
        ['ce']       = { '#569CD6', "Normal Ex Mode" },
        ['!']        = { '#569CD6', "Shell Running" },
        ['ic']       = { '#DCDCAA', 'Insert mode completion |compl-generic|' },
        ['no']       = { '#DCDCAA', 'Operator-pending' },
        ['nov']      = { '#DCDCAA', 'Operator-pending (forced charwise |o_v|)' },
        ['noV']      = { '#DCDCAA', 'Operator-pending (forced linewise |o_V|)' },
        ['noCTRL-V'] = { '#DCDCAA', 'Operator-pending (forced blockwise |o_CTRL-V|) CTRL-V is one character' },
        ['niI']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Insert-mode|' },
        ['niR']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Replace-mode|' },
        ['niV']      = { '#DCDCAA', 'Normal using |i_CTRL-O| in |Virtual-Replace-mode|' },
        ['ix']       = { '#DCDCAA', 'Insert mode |i_CTRL-X| completion' },
        ['Rc']       = { '#DCDCAA', 'Replace mode completion |compl-generic|' },
        ['Rx']       = { '#DCDCAA', 'Replace mode |i_CTRL-X| completion' },
    }

    -- For icons see this cheatsheet and just copy and paste the icons: https://www.nerdfonts.com/cheat-sheet
    -- I use the Nerd Font Sauce Code Pro: https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
    local icons = {
        bracketleft    = '',
        bracketright   = '',
        vim            = '',
        -- vim            = '',
        git            = '',
        -- git            = '',
        github         = '',
        gitlab         = '',
        gitbitbucket   = '',
        hg             = '',
        gitadd         = ' ',
        -- gitadd         = ' ',
        gitmod         = ' ',
        -- gitmod         = '柳',
        gitdel         = ' ',
        -- gitdel         = ' ',
        -- lsp               = '',
        lsp            = '',
        lspdiagerror   = ' ',
        -- lspdiagerror   = ' ',
        lspdiagwarning = ' ',
        -- lspdiagwarning = ' ',
        lspdiaginfo    = ' ',
        -- lspdiaginfo    = ' ',
        -- lspdiaghint    = ' ',
        -- lspdiaghint    = ' ',
        dos            = '',
        unix           = '',
        -- unix           = '',
        mac            = '',
        typewriteable  = '',
        -- typewriteable  = '',
        -- typewriteable  = '',
        typereadonly   = '',
        typesize       = '',
        -- typesize       = '',
        typeenc        = '',
        stats          = '⅑',
        -- statsvert      = '⇳',
        statsvert      = '⬍',
        -- statshoriz     = '⇔',
        statshoriz     = '⬌',
        statsspace     = '⯀',
        statstab       = '⯈',
    }
    -- }}}2

    -- highlight, Insert and Rag status functions {{{2
    local function highlight(group, fg, bg, gui)
        local cmd = string.format('hi! %s guifg=%s guibg=%s', group, fg, bg)
        local cmdInv = string.format('hi! %sInv guifg=%s guibg=%s', group, bg, fg)

        if gui ~= nil then
            cmd = cmd .. ' gui=' .. gui
        end

        vim.cmd(cmd)
        vim.cmd(cmdInv)
    end

    local function highlightGroup(group, icon, bg, text)
        highlight('Lualine' .. group .. 'Lft', icon, colors.bg)
        highlight('Lualine' .. group .. 'Mid', icon, bg)
        highlight('Lualine' .. group .. 'Txt', text, bg)
        highlight('Lualine' .. group .. 'End', bg, colors.bg)
    end

    local function ins_left(component)
        table.insert(lvim.builtin.lualine.sections.lualine_c, component)
    end

    local function ins_right(component)
        table.insert(lvim.builtin.lualine.sections.lualine_x, component)
    end

    local function setLineWidthColours()
        local colbg = colors.statsbg
        local linebg = colors.statsiconbg

        if (vim.fn.col('.') > lineLengthError)
        then
            colbg = colors.linelongerrorfg
        elseif (vim.fn.col('.') > lineLengthWarning)
        then
            colbg = colors.linelongwarnfg
        end

        if (vim.fn.strwidth(vim.fn.getline('.')) > lineLengthError)
        then
            linebg = colors.linelongerrorfg
        elseif (vim.fn.strwidth(vim.fn.getline('.')) > lineLengthWarning)
        then
            linebg = colors.linelongwarnfg
        end

        highlight('LinePosHighlightStart', colbg, colors.statsbg)
        highlight('LinePosHighlightColNum', colors.statstext, colbg)
        highlight('LinePosHighlightMid', linebg, colbg)
        highlight('LinePosHighlightLenNum', colors.statstext, linebg)
        highlight('LinePosHighlightEnd', linebg, colors.statsbg)
    end

    local function getGitUrl()
        local cmd = "git ls-remote --get-url 2> /dev/null"
        local file = assert(io.popen(cmd, 'r'))
        local url = file:read('*all')
        file:close()
        return url
        -- return "github"
    end

    local function getGitIcon()
        local giturl = getGitUrl()

        if giturl == nil then
            return icons['git']
        elseif string.find(giturl, "github") then
            return icons['github']
        elseif string.find(giturl, "bitbucket") then
            return icons['gitbitbucket']
        elseif string.find(giturl, "stash") then
            return icons['gitbitbucket']
        elseif string.find(giturl, "gitlab") then
            return icons['gitlab']
        elseif string.find(giturl, "hg") then
            return icons['hg']
        end

        return icons['git']
    end

    local conditions = {
        display_mode  = function() return vim.fn.winwidth(0) > 60 end,
        display_pos   = function() return vim.fn.winwidth(0) > 80 end,
        display_stats = function() return vim.fn.winwidth(0) > 100 end,
        display_git   = function()
            if getGitUrl() == nil then
                return false
            end

            return vim.fn.winwidth(0) > 120
        end,
        display_lsp   = function()
            local clients = vim.lsp.get_active_clients()

            if next(clients) == nil then
                return false
            end

            return vim.fn.winwidth(0) > 140
        end,
    }
    -- }}}2

    -- }}}1

    -- Left {{{1

    -- Vi Mode {{{2
    ins_left {
        function()
            highlight('LualineMode', colors.bg, mode_map[vim.fn.mode()][1])
            highlight('LualineModeText', colors.modetext, mode_map[vim.fn.mode()][1])
            return icons['bracketleft']
        end,
        color = 'LualineModeInv',
        cond = conditions.display_mode,
        padding = { left = 1, right = 0 }
    }
    ins_left {
        function()
            return mode_map[vim.fn.mode()][2]
        end,
        color = 'LualineModeText',
        cond = conditions.display_mode,
        icon = icons['vim'],
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function()
            return icons['bracketright']
        end,
        color = 'LualineModeInv',
        cond = conditions.display_mode,
        padding = { left = 0, right = 0 }
    }
    -- }}}2

    -- Git info {{{2

    -- Git Branch Name {{{3
    ins_left {
        function()
            highlightGroup('Git', colors.giticonbg, colors.gitbg, colors.gittext)
            return icons['bracketleft']
        end,
        color = 'LualineGitLft',
        cond = conditions.display_git,
        padding = { left = 1, right = 0 }
    }
    ins_left {
        function() return getGitIcon() end,
        color = 'LualineGitMidInv',
        cond = conditions.display_git,
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function() return icons['bracketright'] end,
        color = 'LualineGitMid',
        cond = conditions.display_git,
        padding = { left = 0, right = 0 }
    }
    ins_left {
        'branch',
        color = 'LualineGitTxt',
        cond = conditions.display_git,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    -- }}}3

    -- Git diffs {{{3
    ins_left {
        'diff',
        color = 'LualineGitTxt',
        symbols = { added = icons['gitadd'], modified = icons['gitmod'], removed = icons['gitdel'] },
        diff_color = {
            added = { fg = "#ffffff", bg = colors.gitbg },
            modified = { fg = colors.orange, bg = colors.gitbg },
            removed = { fg = colors.red, bg = colors.gitbg },
        },
        cond = conditions.display_git,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function() return icons['bracketright'] end,
        color = 'LualineGitEnd',
        cond = conditions.display_git,
        padding = { left = 0, right = 0 }
    }
    -- }}}3

    -- }}}2

    -- Lsp Section {{{2

    -- Lsp Client {{{3
    ins_left {
        function()
            highlightGroup('Lsp', colors.lspiconbg, colors.lspbg, colors.lsptext)
            return icons['bracketleft']
        end,
        color = 'LualineLspLft',
        cond = conditions.display_lsp,
        padding = { left = 1, right = 0 }
    }
    ins_left {
        function() return icons['lsp'] end,
        color = 'LualineLspMidInv',
        cond = conditions.display_lsp,
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function() return icons['bracketright'] end,
        color = 'LualineLspMid',
        cond = conditions.display_lsp,
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function()
            local msg = 'No Active Lsp'
            local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then return msg end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
            return msg
        end,
        color = 'LualineLspTxt',
        cond = conditions.display_lsp,
        padding = { left = 1, right = 1 }
    }
    -- }}}3

    -- Diagnostics {{{3
    ins_left {
        'diagnostics',
        sources = { "nvim_lsp" },
        symbols = {
            error = icons['lspdiagerror'],
            warn = icons['lspdiagwarning'],
            info = icons['lspdiaginfo'],
            hint = icons['lspdiaghint']
        },
        diagnostics_color = {
            error = { fg = colors.diagerror, bg = colors.lspbg },
            warn = { fg = colors.diagwarning, bg = colors.lspbg },
            info = { fg = colors.diaginfo, bg = colors.lspbg },
            hint = { fg = colors.diaghint, bg = colors.lspbg },
        },
        color = 'LualineLspMid',
        cond = conditions.display_lsp,
        padding = { left = 0, right = 0 }
    }
    ins_left {
        function() return icons['bracketright'] end,
        color = 'LualineLspEnd',
        cond = conditions.display_lsp,
        padding = { left = 0, right = 0 }
    }
    -- }}}3

    -- }}}2

    -- }}}1

    -- Right {{{1

    -- Type {{{2
    ins_right {
        function()
            highlightGroup('Type', colors.typeiconbg, colors.typebg, colors.typetext)
            return icons['bracketleft']
        end,
        color = 'LualineTypeLft',
        cond = conditions.display_stats,
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function() return icons[vim.bo.fileformat] or '' end,
        color = 'LualineTypeMidInv',
        cond = conditions.display_stats,
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function() return icons['bracketright'] end,
        color = 'LualineTypeMid',
        cond = conditions.display_stats,
        padding = { left = 0, right = 0 }
    }

    -- File type icon.
    ins_right {
        function()
            local filetype = vim.bo.filetype
            if filetype == '' then return '' end
            local filename, fileext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
            local icon = require('nvim-web-devicons').get_icon(filename, fileext, { default = true })
            return string.format('%s', icon)
        end,
        color = 'LualineTypeMid',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }

    -- File name.
    ins_right {
        function()
            local filenameColour = colors.typetext
            local isModified = vim.bo.modified
            local isReadonly = vim.bo.readonly or not vim.bo.modifiable

            if isModified
            then
                filenameColour = colors.typetextmodified
            elseif isReadonly then
                filenameColour = colors.typetextreadonly
            end

            highlight('LualineTypeFileName', filenameColour, colors.typebg)
            return '%t'
        end,
        color = 'LualineTypeFileName',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }

    -- -- Padlock if the file is readonly.
    -- ins_right {
    --     function()
    --         local lockcolour = colors.typeiconbgrw
    --         local lockicon = icons['typewriteable']
    --         local isReadonly = vim.bo.readonly or not vim.bo.modifiable
    --         if isReadonly
    --         then
    --             lockcolour = colors.typeiconbgro
    --             lockicon = icons['typereadonly']
    --         end
    --         highlight('LualineTypeMidLock', lockcolour, colors.typebg)
    --         return lockicon
    --     end,
    --     color = 'LualineTypeMidLock',
    --     cond = conditions.display_stats,
    --     padding = { left = 1, right = 0 }
    -- }

    -- File type text.
    ins_right {
        function() return vim.bo.filetype end,
        color = 'LualineTypeTxt',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }

    -- File size icon.
    ins_right {
        function() return icons['typesize'] end,
        color = 'LualineTypeMid',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }
    -- File size in b, k, m or g.
    ins_right {
        function()
            local function format_file_size(file)
                local size = vim.fn.getfsize(file)
                if size <= 0 then return '' end
                local sufixes = { 'b', 'k', 'm', 'g' }
                local i = 1
                while size > 1024 do
                    size = size / 1024
                    i = i + 1
                end

                if (i == 1)
                then
                    return string.format('%.0f%s', size, sufixes[i])
                end

                return string.format('%.1f%s', size, sufixes[i])
            end
            local file = vim.fn.expand('%:p')
            if string.len(file) == 0 then return '' end
            return format_file_size(file)
        end,
        color = 'LualineTypeTxt',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }
    ins_right {
        function() return icons['typeenc'] end,
        color = 'LualineTypeMid',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }
    ins_right {
        'encoding',
        color = 'LualineTypeTxt',
        cond = conditions.display_stats,
        padding = { left = 1, right = 0 }
    }
    ins_right {
        function() return icons['bracketright'] end,
        color = 'LualineTypeEnd',
        cond = conditions.display_stats,
        padding = { left = 0, right = 0 }
    }
    -- }}}2

    -- Cursor Position/Stats Section {{{2
    ins_right {
        function()
            highlightGroup('Stats', colors.statsiconbg, colors.statsbg, colors.statstext)
            return icons['bracketleft']
        end,
        color = 'LualineStatsLft',
        cond = conditions.display_pos,
        padding = { left = 1, right = 0 }
    }
    ins_right {
        function() return icons['stats'] end,
        color = 'LualineStatsMidInv',
        cond = conditions.display_pos,
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function() return icons['bracketright'] end,
        color = 'LualineStatsMid',
        cond = conditions.display_pos,
        padding = { left = 0, right = 0 }
    }
    -- Percentage/Top/Bottom/All
    ins_right {
        'progress',
        color = 'LualineStatsTxt',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    -- Vertical icon.
    ins_right {
        function() return icons['statsvert'] end,
        color = 'LualineStatsMid',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 1, right = 0 }
    }
    -- File line position and number of lines.
    ins_right {
        function()
            return string.format("%4s/%4i", "%l", vim.fn.line('$'))
        end,
        color = 'LualineStatsTxt',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    -- Horiz icon.
    ins_right {
        function() return icons['statshoriz'] end,
        color = 'LualineStatsMid',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    -- Left bracket for line length.
    ins_right {
        function()
            setLineWidthColours()
            return icons['bracketleft']
        end,
        color = 'LinePosHighlightStart',
        cond = conditions.display_pos,
        padding = { left = 1, right = 0 }
    }
    -- Column and line width
    ins_right {
        function()
            return string.format("%4s", "%c")
        end,
        color = 'LinePosHighlightColNum',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }

    }
    ins_right {
        function()
            return icons['bracketleft']
        end,
        color = 'LinePosHighlightMid',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function()
            return string.format("%4i", string.len(vim.fn.getline('.')))
        end,
        color = 'LinePosHighlightLenNum',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function()
            return icons['bracketright']
        end,
        color = 'LinePosHighlightEnd',
        cond = conditions.display_pos,
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function()
            if vim.bo.expandtab
            then
                return icons['statsspace']
            else
                return icons['statstab']
            end
        end,
        color = 'LualineStatsMid',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function() return '' .. vim.bo.shiftwidth end,
        color = 'LualineStatsTxt',
        cond = conditions.display_pos,
        icon = '',
        padding = { left = 0, right = 0 }
    }
    ins_right {
        function() return icons['bracketright'] end,
        color = 'LualineStatsEnd',
        cond = conditions.display_pos,
        padding = { left = 0, right = 1 }
    }
    -- }}}2

    -- }}}1
end
