return {
    {
        "catppuccin/nvim",
        opts = {
            -- enable transparent background
            transparent_background = true,
            custom_highlights = function(_)
                return {
                    WinSeparator = { fg = "#cba6f7" },
                }
            end,
        },
    },

    -- Configure LazyVim to load the catppuccin theme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-mocha",
        },
    },
}
