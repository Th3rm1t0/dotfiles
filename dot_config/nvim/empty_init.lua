-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Plugin manager
require("config.lazy")

