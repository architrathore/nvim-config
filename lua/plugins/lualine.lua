return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        sections = {
            lualine_c = {
                {
                    "filename",
                    path = 1,
                },
            },
            lualine_x = {
                -- "venv-selector",
                "filetype",
            },
        },
    },
}
-- return {}
