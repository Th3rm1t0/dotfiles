return {
    dir = require("nix_plugins")["gitsigns-nvim"],
    name = "gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local map = function(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
            end
            map("n", "]c", gitsigns.next_hunk, "to the next hunk")
            map("n", "[c", gitsigns.prev_hunk, "to the previous hunk")
            map("n", "<leader>hs", gitsigns.stage_hunk, "stage the current hunk")
            map("n", "<leader>hr", gitsigns.reset_hunk, "reset the current hunk")
            map("n", "<leader>hp", gitsigns.preview_hunk, "preview the current hunk")
        end,
    },
}
