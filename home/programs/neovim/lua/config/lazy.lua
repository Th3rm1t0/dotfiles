local lazypath = require("nix_plugins")["lazy-nvim"]
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { missing = false },
	checker = { enabled = false },
	change_detection = { enabled = false },
})
