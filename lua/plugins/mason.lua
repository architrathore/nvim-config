local ensure_installed = {}

-- Pin LSP versions on remote machines; locally, Mason installs latest by default.
if os.getenv("SSH_TTY") then
    ensure_installed = {
        "ty@0.0.14",
        "ruff@0.14.0",
    }
end

return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = ensure_installed,
    },
}
