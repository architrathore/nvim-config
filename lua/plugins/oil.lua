return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name, bufnr)
                -- don't show .watchman-cookie* files
                return name:match("^%.watchman%-cookie") ~= nil
            end,
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>do", "<cmd>Oil --float<cr>", desc = "[D]irectory [O]pen (using Oil)" },
    },
}
