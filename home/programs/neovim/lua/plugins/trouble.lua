return {
    dir = require("nix_plugins")["trouble-nvim"],
    name = "trouble.nvim",
    cmd = "Trouble",
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "diagnostics" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "quickfix list" },
    },
    dependencies = {
        { dir = require("nix_plugins")["nvim-web-devicons"], name = "nvim-web-devicons" },
    },
    opts = {},
}
