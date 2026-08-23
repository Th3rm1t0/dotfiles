local augroup = vim.api.nvim_create_augroup("user_config", {})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight yanked text",
    callback = function()
        vim.highlight.on_yank()
    end,
})
