-- dapui の内部トラッキングに頼らず、バッファ名で直接一掃する
local function force_close_dap_ui()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        if name:match("^DAP ") or name:match("dap%-repl") then
            pcall(vim.api.nvim_win_close, win, true)
        end
    end
end

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
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                    require("dapui").close()
                    force_close_dap_ui()
                end,
                desc = "Terminate Debugging",
            },
        },
    },
    {
        dir = require("nix_plugins")["nvim-dap-ui"],
        name = "nvim-dap-ui",
        -- <leader>du 未押下だとリスナー未登録のままセッションが進むため VeryLazy で先読み
        event = "VeryLazy",
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