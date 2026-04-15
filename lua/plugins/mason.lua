local pinned_lsp_versions = {
    ty = "0.0.14",
    ruff = "0.14.0",
}

local host_type_file = "/pay/conf/host_type"

local function get_host_type()
    local lines = vim.fn.readfile(host_type_file)
    if vim.v.shell_error ~= 0 or not lines or #lines == 0 then
        return nil
    end

    local host_type = vim.trim(lines[1] or "")
    if host_type == "" then
        return nil
    end

    return host_type
end

local function is_remote()
    return get_host_type() ~= nil
end

local function pinned_lsp_specs()
    local specs = {}
    for server, version in pairs(pinned_lsp_versions) do
        specs[#specs + 1] = ("%s@%s"):format(server, version)
    end
    table.sort(specs)
    return specs
end

local function ensure_pinned_remote_packages(registry)
    if not is_remote() then
        return
    end

    for package_name, version in pairs(pinned_lsp_versions) do
        local pkg = registry.get_package(package_name)
        local installed_version = pkg:get_installed_version()
        if installed_version ~= version and not pkg:is_installing() and not pkg:is_uninstalling() then
            pkg:install({ version = version }, function(success, err)
                if not success then
                    vim.schedule(function()
                        vim.notify(
                            ("mason: failed to install %s@%s: %s"):format(package_name, version, err),
                            vim.log.levels.ERROR
                        )
                    end)
                end
            end)
        end
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            if not is_remote() then
                return
            end

            opts.servers = opts.servers or {}
            for server in pairs(pinned_lsp_versions) do
                opts.servers[server] = vim.tbl_deep_extend("force", opts.servers[server] or {}, {
                    mason = false,
                })
            end
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            if is_remote() then
                vim.list_extend(opts.ensure_installed, pinned_lsp_specs())
            end
        end,
    },
    {
        "mason-org/mason.nvim",
        config = function(_, opts)
            require("mason").setup(opts)

            local registry = require("mason-registry")
            registry:on("package:install:success", function()
                vim.defer_fn(function()
                    -- Re-trigger FileType so LSPs can attach after Mason installs complete.
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            registry.refresh(function()
                for _, tool in ipairs(opts.ensure_installed or {}) do
                    local pkg = registry.get_package(tool)
                    if not pkg:is_installed() then
                        pkg:install()
                    end
                end

                ensure_pinned_remote_packages(registry)
            end)
        end,
    },
}
