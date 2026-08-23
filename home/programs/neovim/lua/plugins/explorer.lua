return {
    dir = require("nix_plugins")["neo-tree-nvim"],
    name = "neo-tree.nvim",
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "toggle file explorer" },
    },
    dependencies = {
        { dir = require("nix_plugins")["plenary-nvim"], name = "plenary.nvim" },
        { dir = require("nix_plugins")["nvim-web-devicons"], name = "nvim-web-devicons" },
    },
    opts = {
        close_if_last_window = true,
        filesystem = { follow_current_file = { enabled = true } },
    },
}
