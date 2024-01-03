return {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "[C]ode [S]ymbols toggle" },
    },
}
