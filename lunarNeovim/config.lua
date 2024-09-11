-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- @note: 将当前目录加入到package.path中
-- @note: 必须定义环境变量 MY_LVIM_CONFIG_FOLDER
-- @note: 例如：export MY_LVIM_CONFIG_FOLDER=$HOME/.config/lvim

local include_path = ""
if os.getenv("MY_LVIM_CONFIG_FOLDER") ~= nil then
    include_path = ";" .. os.getenv("MY_LVIM_CONFIG_FOLDER") .. "/conf/?.lua"
else
    include_path = ";" .. "/home/lap/.config/lvim" .. "/conf/?.lua"
end
-- package.path = package.path ..
package.path = package.path .. include_path
require("vide")
lvim.plugins = require("plugins")
require("dap")

lvim.transparent_window = false
-- lvim.builtin.lualine.options.theme = "onedarker"
-- lvim.colorscheme = "onedark"
-- lvim.colorscheme = "tokyonight-moon"

vim.opt.guifont = "FiraCode Nerd Font Ret:h13"
vim.opt.tabstop = 4
vim.opt.fileencoding = "utf-8"
vim.opt.relativenumber = true
lvim.format_on_save = true


vim.keymap.set({ "n", "v" }, "<M-v>", ":vsplit<cr>")
vim.keymap.set({ "n", "v" }, "<M-h>", ":split<cr>")
vim.keymap.set({ "n", "v" }, "<M-c>", ":close<cr>")
vim.keymap.set({ "n", "v" }, "U", "<c-r>")

-- @note: 将通知取消
vim.keymap.set({ "n", "v" }, "<Space>nc", ":Noice dismiss<CR>")

-- @note: rust 运行调试
lvim.keys.normal_mode["<TAB>rr"] = ":RustLsp run<CR>"
lvim.keys.normal_mode["<TAB>rd"] = ":RustLsp debuggables<CR>"
lvim.keys.normal_mode["<TAB>rt"] = ":RustLsp testables<CR>"
lvim.keys.normal_mode['<TAB>rl'] = ":RustLsp runnables<CR>"

--@note: go 运行调试
lvim.keys.normal_mode["<TAB>gr"] = ":GoRun<CR>"
lvim.keys.normal_mode["<TAB>gd"] = ":GoDebug<CR>"
lvim.keys.normal_mode["<TAB>gs"] = ":GoStop<CR>"

-- @note: python code run
lvim.keys.normal_mode["<TAB>py"] = ":PyRun<CR>"

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

-- @note: run python code
vim.api.nvim_create_user_command('PyRun', function()
    -- Get the current buffer's file path
    local file_path = vim.fn.expand('%:p')

    -- Check if the current file is a Python file
    if vim.fn.expand('%:e') ~= 'py' then
        vim.notify("Current file is not a Python file.", vim.log.levels.ERROR)
        return
    end

    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)

    -- Run the Python file and capture the output
    local output = vim.fn.system('python3 ' .. vim.fn.shellescape(file_path))

    -- Prepare the content for the buffer
    local content = {}
    for line in output:gmatch("[^\r\n]+") do
        table.insert(content, line)
    end

    -- Set the buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    -- Open a new window below and set it to our buffer
    vim.api.nvim_open_win(buf, true, {
        relative = 'win',
        row = vim.api.nvim_win_get_height(0) + 1,
        col = 0,
        width = vim.api.nvim_win_get_width(0),
        height = 10,
        border = "rounded",
        title = ('Python Output: %s'):format(file_path),
        title_pos = 'center',
    })
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
end, {
    desc = { 'Run Python code',
    },
})

-- @note: 这是内置lsp代码hint
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

local telescopebuiltin = require('telescope.builtin')

local function on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', function() telescopebuiltin.lsp_definitions { fname_width = 0.4 } end, bufopts) -- 跳转定义
    vim.keymap.set('n', 'gr', function() telescopebuiltin.lsp_references { fname_width = 0.4 } end, bufopts)  -- 查找引用
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
        { callback = vim.lsp.buf.document_highlight, buffer = bufnr })                                        -- 光标不动时高亮变量名
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' },
        { callback = vim.lsp.buf.clear_references, buffer = bufnr })                                          -- 移动光标时清除高亮
end

require("lspconfig").clangd.setup({
    on_attach = on_attach,
    cmd = { "/usr/bin/clangd", "--background-index", "--header-insertion=never", "--offset-encoding=utf-16" },
    filetypes = { "c", "cpp", "cuda", "proto", "objc", "objcpp" },
    root_dir = require("lspconfig/util").root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".clangd",
        ".clang-tidy", ".clang-format"),
    single_file_support = true,
})

lvim.lsp.automatic_servers_installation = false
lvim.lsp.installer.setup.ensure_installed = {
    "html"
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
lvim.lsp.installer.setup.automatic_installation = {
    exclude = { "rust_analyzer", "rust-analyzer", "pyright" }
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
