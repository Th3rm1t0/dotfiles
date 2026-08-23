return {
    dir = require("nix_plugins")["tokyonight-nvim"],
    name = "tokyonight",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("tokyonight")
    end,
}
