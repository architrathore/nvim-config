return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- bigfile = { enabled = true },
        -- dashboard = { enabled = true },
        -- explorer = { enabled = false },
        -- indent = { enabled = false },
        -- input = { enabled = true },
        picker = {
            layout = {
                layout = {
                    backdrop = false,
                    width = 0.85,
                    min_width = 80,
                    height = 0.8,
                    min_height = 30,
                    box = "vertical",
                    border = true,
                    title = "{title} {live} {flags}",
                    title_pos = "center",
                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", height = 10, border = "none" },
                    { win = "preview", title = "{preview}", height = 0.9, border = "top" },
                },
            },
        },
        -- notifier = { enabled = false },
        -- quickfile = { enabled = false },
        -- scope = { enabled = false },
        scroll = { enabled = false },
        -- statuscolumn = { enabled = false },
        -- words = { enabled = false },
    },
}
