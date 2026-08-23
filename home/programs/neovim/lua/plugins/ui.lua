return {
    {
        dir = require("nix_plugins")["nvim-web-devicons"],
        name = "nvim-web-devicons",
        lazy = true,
    },
    {
        dir = require("nix_plugins")["lualine-nvim"],
        name = "lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            { dir = require("nix_plugins")["nvim-web-devicons"], name = "nvim-web-devicons" },
        },
        opts = { options = { theme = "tokyonight" } },
    },
    {
        dir = require("nix_plugins")["bufferline-nvim"],
        name = "bufferline.nvim",
        event = "VeryLazy",
        dependencies = {
            { dir = require("nix_plugins")["nvim-web-devicons"], name = "nvim-web-devicons" },
        },
        keys = {
            { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "next buffer" },
            { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "previous buffer" },
        },
        opts = {},            
    },
}
