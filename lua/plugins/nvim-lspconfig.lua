return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            -- Register your custom server name here.
            servers = {
                zlsp = {},
            },
            -- Use the `setup` key to override specific server setups.
            setup = {
                zlsp = function(_, server_opts)
                    -- First, ensure that the custom server is registered.
                    local configs = require("lspconfig.configs")
                    if not configs.zlsp then
                        configs.zlsp = {
                            default_config = {
                                cmd = {
                                    "/Users/architr/.cache-zoolander/prebuilt-binaries-cache/zlsp/01f22e421138b62767a5a6ceba0d0a45e443585e3785546f01a96976fef70f70/bin",
                                    "lsp",
                                    "--buildhelper=false",
                                    "--allowlists=src/python/monolint/python/allowlist",
                                },
                                filetypes = { "bzl", "BUILD.bazel", "python" },
                                root_dir = require("lspconfig.util").root_pattern("WORKSPACE"),
                                -- You can add any additional default settings here.
                            },
                        }
                    end

                    -- Merge any additional opts from LazyVim with your defaults.
                    require("lspconfig").zlsp.setup(vim.tbl_deep_extend("force", {
                        -- Place any extra custom settings here.
                    }, server_opts))

                    -- Return true to stop LazyVim from applying its own setup.
                    return true
                end,
            },
        },
    },
}
