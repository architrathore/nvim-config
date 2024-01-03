return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            pyright = {},
            ruff_lsp = {
                enabled = false,
            },
        },
    },
}
