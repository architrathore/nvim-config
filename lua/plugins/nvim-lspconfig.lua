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
                                    "/Users/architr/.cache-zoolander/prebuilt-binaries-cache/zlsp/4db39569fe9b429688529f45ca7a0376fcc2e51a52b6e6fc258a6584d612db19/bin",
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
