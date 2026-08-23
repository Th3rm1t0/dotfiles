return {
    {
        dir = require("nix_plugins")["nvim-autopairs"],
        name = "nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        dir = require("nix_plugins")["comment-nvim"],
        name = "comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "toggle line comment" },
            { "gc", mode = { "n", "v" }, desc = "toggle comment" },
        },
        opts = {},
    },
}
