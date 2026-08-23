return {
  dir = require("nix_plugins")["neotest"],
  name = "neotest",
  ft = "go",
  dependencies = {
    { dir = require("nix_plugins")["plenary-nvim"], name = "plenary.nvim" },
    { dir = require("nix_plugins")["nvim-nio"], name = "nvim-nio" },
    { dir = require("nix_plugins")["neotest-golang"], name = "neotest-golang" },
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run tests in file" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-golang")({
          dap_go_enabled = true,
          go_test_args = { "-count=1", "-v" },
        }),
      },
    })
  end,
}
