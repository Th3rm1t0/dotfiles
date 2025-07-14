-- 自動コマンド
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ファイル保存時の自動フォーマット
autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- ヤンクのハイライト
autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})
