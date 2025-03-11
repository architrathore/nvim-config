return {
    {
        "catppuccin/nvim",
        opts = {
            -- enable transparent background
            transparent_background = true,
            custom_highlights = function(_)
                return {
                    WinSeparator = { fg = "#cba6f7" }, -- Set the window separator to white
                }
            end,
        },
    },
    { "rjshkhr/shadow.nvim" },

    -- Configure LazyVim to load the catppuccin theme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-mocha",
            -- colorscheme = "shadow",
        },
    },
}
