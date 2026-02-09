return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, opts)
        opts.sections.lualine_c = {
            { "filename", path = 1 },
        }
        -- Append to existing lualine_x (arrays don't merge, they replace)
        table.insert(opts.sections.lualine_x, "venv-selector")
        table.insert(opts.sections.lualine_x, "filetype")
    end,
}
