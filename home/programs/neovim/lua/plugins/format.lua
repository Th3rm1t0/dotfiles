return {
    dir = require("nix_plugins")["conform-nvim"],
    name = "conform.nvim",
    event = { "BufReadPre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            lua = { "stylua" },
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}
