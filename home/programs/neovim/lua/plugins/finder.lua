return {
    dir = require("nix_plugins")["fzf-lua"],
    name = "fzf-lua",
    cmd = "FzfLua",
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "files search" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "grep search" },
        { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "buffers search" },
        { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "help search" }, 
    },
    opts = {},
}
