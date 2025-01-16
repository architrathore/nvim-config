return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        winopts = {
            -- fullscreen = true,
            preview = {
                layout = "vertical",
                vertical = "down:80%",
            },
        },
    },
}
