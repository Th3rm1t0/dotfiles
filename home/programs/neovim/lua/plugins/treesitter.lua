return {
    dir = require("nix_plugins")["nvim-treesitter"],
    name = "nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        -- ハイライト/インデントは vim.treesitter.start() 側で有効化する(.configs は廃止済み)
        require("nvim-treesitter").setup({})

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local ok = pcall(vim.treesitter.start, args.buf)
                if ok then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}