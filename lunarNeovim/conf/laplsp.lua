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

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer", "typst_lsp", "typst-lsp" })
lvim.lsp.installer.setup.automatic_installation = {
    exclude = { "rust_analyzer", "rust-analyzer", "pyright", "typst_lsp", "typst-lsp" }
}

-- Add files/folders here that indicate the root of a project

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'typst',
    callback = function(args)
        local root_markers = { '.git', '.editorconfig', 'typst.toml' }
        local match = vim.fs.find(root_markers, { path = args.file, upward = true })[1]
        local root_dir = match and vim.fn.fnamemodify(match, ':p:h') or nil
        vim.lsp.start({
            name = 'tinymist',
            cmd = { 'tinymist' },
            root_dir = root_dir,
        })
    end,
})

require("lspconfig").tinymist.setup({
    offset_encoding = "utf-8",
    settings = {
        formatterMode = "typstyle",
    }
})
