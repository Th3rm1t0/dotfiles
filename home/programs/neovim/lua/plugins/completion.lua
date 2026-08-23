return {
    dir = require("nix_plugins")["blink-cmp"],
    name = "blink.cmp",
    event = "InsertEnter",
    opts = {
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        sources = { default = { "lsp", "path", "buffer" } },
    },
}
