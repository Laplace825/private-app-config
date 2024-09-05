-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- @note: 将当前目录加入到package.path中
package.path = package.path .. ";./conf/?.lua"
require("conf.neovide")
lvim.plugins = require("conf.plugins")
require("conf.dap")

lvim.transparent_window = false
-- lvim.builtin.lualine.options.theme = "onedarker"
-- lvim.colorscheme = "onedark"
lvim.colorscheme = "tokyonight-moon"

vim.opt.guifont = "FiraCode Nerd Font Ret:h13"
vim.opt.tabstop = 4
vim.opt.fileencoding = "utf-8"
vim.opt.relativenumber = true
-- lvim.format_on_save = true


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


-- @note: 这是内置lsp代码hint
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

require("lspconfig").clangd.setup({
    cmd = { "/usr/bin/clangd", "--background-index", "--header-insertion=never" },
    filetypes = { "c", "cpp", "cuda", "proto", "objc", "objcpp" },
    root_dir = require("lspconfig/util").root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".clangd",
        ".clang-tidy", ".clang-format"),
    single_file_support = true,
})

require("lspconfig").pyright.setup({
    cmd = { "/home/lap/miniconda3/bin/pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = require("lspconfig/util").root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml",
        "requirements.txt", "pyrightconfig.json"),
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
            },
        },
    },
    single_file_support = true
})


lvim.lsp.automatic_servers_installation = false
lvim.lsp.installer.setup.ensure_installed = {
    "html"
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
lvim.lsp.installer.setup.automatic_installation = {
    exclude = { "rust_analyzer", "rust-analyzer" }
}

require("markview").setup({
  modes = { "n", "no", "c" },   -- Change these modes
  -- to what you need

  hybrid_modes = { "n" },   -- Uses this feature on
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
