return {
    {
        "catppuccin/nvim",
        opts = {
            -- enable transparent background
            transparent_background = true,
            custom_highlights = function(colors)
                return {
                    WinSeparator = { fg = colors.mauve },
                    -- fff.nvim picker chrome
                    FFFBorder = { fg = colors.mauve },
                    FFFTitle = { fg = colors.mauve, bold = true },
                    FFFPrompt = { fg = colors.blue, bold = true },
                    FFFMatched = { fg = colors.peach, bold = true },
                    FFFCursor = { bg = colors.surface1, bold = true },
                    FFFFrecency = { fg = colors.yellow },
                    FFFDirectory = { fg = colors.overlay1, italic = true },
                    FFFScrollbar = { fg = colors.surface2 },
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
