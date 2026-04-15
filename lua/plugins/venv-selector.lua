local function ty_venv_hook(venv_python, _, bufnr)
    -- ty expects interpreter selection through its own configuration schema.
    -- The default venv-selector restart hook rewrites Python-LSP-style
    -- settings, which ty rejects and can surface as noisy startup failures.
    if not venv_python or venv_python == "" then
        return 1
    end

    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local updated = false
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "ty" })) do
        -- Keep the existing client alive so opening a buffer does not race with
        -- a stop/start cycle just to point ty at a different interpreter.
        local settings = vim.tbl_deep_extend("force", client.config.settings or {}, {
            ty = {
                configuration = {
                    environment = {
                        python = venv_python,
                    },
                },
            },
        })

        client.config.settings = settings
        client.settings = settings
        -- A config-change notification is enough because ty resolves imports
        -- and site-packages from its configuration payload, so no full restart
        -- is needed when the selected venv changes.
        client:notify("workspace/didChangeConfiguration", { settings = settings })
        updated = true
    end

    return updated and 1 or 0
end

return {
    "linux-cultist/venv-selector.nvim",
    opts = {
        hooks = { ty_venv_hook },
        search = {
            workspace = false,
            cwd = false,
        },
    },
}
