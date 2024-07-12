return {
    "neovim/nvim-lspconfig",
    opts = {
        inlay_hints = { enabled = true },
        servers = {
            basedpyright = {
                analysis = { typeCheckingMode = "standard" },
            },
            pyright = {},
        },
    },
}
