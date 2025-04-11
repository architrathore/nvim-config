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
                                    "/Users/architr/.cache-zoolander/prebuilt-binaries-cache/zlsp/7da0639cadff0a67f13ea2ad93e1df7062f254da693e95ab737dce353b6acaa6/bin",
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
