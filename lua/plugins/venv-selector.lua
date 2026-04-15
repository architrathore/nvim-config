local zoolander = require("config.zoolander")

local function ty_venv_hook(venv_python, _, bufnr)
    if not venv_python or venv_python == "" then
        return 1
    end

    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local overlay_python = zoolander.write_ty_overlay(venv_python)
    if not overlay_python then
        return 0
    end

    local updated = false

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "ty" })) do
        local settings = {
            ty = {
                configuration = {
                    environment = {
                        python = overlay_python,
                    },
                },
            },
        }

        local current_python = vim.tbl_get(client.config.settings, "ty", "configuration", "environment", "python")
        if current_python == overlay_python then
            updated = true
        else
            -- ty 0.0.30 still ignores config-change notifications for this path,
            -- so switching universes requires a client restart.
            client.config.settings = settings
            client.settings = settings
            client:_restart(500)
            updated = true
        end
    end

    return (updated or overlay_python ~= nil) and 1 or 0
end

local function remote_searches()
    if not zoolander.is_remote() then
        return {}
    end

    local zoo_dir = zoolander.find_root()
    if not zoo_dir then
        return {}
    end

    return {
        zoolander_universes = {
            command = ("find '%s' -maxdepth 3 -path '%s/py_universe_*/bin/python' -print | sort"):format(zoo_dir, zoo_dir),
        },
    }
end

return {
    "linux-cultist/venv-selector.nvim",
    opts = function(_, opts)
        opts.hooks = { ty_venv_hook }

        opts.search = vim.tbl_extend("force", opts.search or {}, {
            workspace = false,
            cwd = false,
        }, remote_searches())
    end,
}
