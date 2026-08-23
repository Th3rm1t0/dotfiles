return {
    {
        dir = require("nix_plugins")["nvim-dap"],
        name = "nvim-dap",
         keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Start/Continue Debugging" },
            { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        },
    },
    {
        dir = require("nix_plugins")["nvim-dap-ui"],
        name = "nvim-dap-ui",
        dependencies = {
            { dir = require("nix_plugins")["nvim-dap"], name = "nvim-dap" },
            { dir = require("nix_plugins")["nvim-nio"], name = "nvim-nio" },
        },
        keys = {
            { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
    },
    {
        dir = require("nix_plugins")["nvim-dap-go"],
        name = "nvim-dap-go",
        dependencies = {
            { dir = require("nix_plugins")["nvim-dap"], name = "nvim-dap" },
        },
        ft = { "go", "gomod" },
        config = function()
            require("dap-go").setup({ delve = { path = "dlv" } })
        end,
    },
}