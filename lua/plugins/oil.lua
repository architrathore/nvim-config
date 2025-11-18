return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>do", "<cmd>Oil --float<cr>", desc = "[D]irectory [O]pen (using Oil)" },
    },
}
