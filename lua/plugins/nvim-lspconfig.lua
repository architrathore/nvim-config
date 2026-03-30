--- Find the zoolander root directory across Mac, devbox, and mydata environments.
--- Checks these paths in order:
---   Mac (mint monorepo): ~/stripe/mint/zoolander
---   Mac (legacy):        ~/stripe/zoolander
---   Devbox/mydata:       /pay/src/zoolander
--- @return string|nil zoolander root path, or nil if not found
local function find_zoolander_root()
    local candidates = {
        vim.fn.expand("~/stripe/mint/zoolander"),
        vim.fn.expand("~/stripe/zoolander"),
        "/pay/src/zoolander",
    }
    for _, dir in ipairs(candidates) do
        if vim.fn.isdirectory(dir) == 1 and vim.fn.filereadable(dir .. "/WORKSPACE") == 1 then
            return dir
        end
    end
    return nil
end

--- Build the zlsp lspconfig definition for a given zoolander root.
--- Uses the dev/py zlsp wrapper which auto-resolves the correct
--- prebuilt binary (see RUN_PYTHON-586).
--- @param zoo_dir string
--- @return table lspconfig server definition
local function zlsp_config(zoo_dir)
    return {
        default_config = {
            cmd = {
                zoo_dir .. "/dev/py",
                "zlsp",
                "lsp",
                "--buildhelper=true",
                "--buildhelper-fully-managed-only=true",
                "--allowlists=" .. zoo_dir .. "/src/python/monolint/python/allowlist",
                "--allowlists=" .. zoo_dir .. "/tools/build_rules/py/private/ratchets",
                "--allowlists=" .. zoo_dir .. "/py",
                "--py-deps=" .. zoo_dir .. "/third_party/py",
                "--semantic-highlighting=true",
            },
            filetypes = { "bzl", "BUILD.bazel", "python" },
            root_dir = require("lspconfig.util").root_pattern("WORKSPACE"),
        },
    }
end

--- Register and setup the zlsp language server with lspconfig.
--- @param server_opts table opts passed through from LazyVim
--- @return boolean true to prevent LazyVim from applying its own setup
local function setup_zlsp(_, server_opts)
    local configs = require("lspconfig.configs")
    if not configs.zlsp then
        local zoo_dir = find_zoolander_root()
        if not zoo_dir then
            vim.notify("zlsp: could not find zoolander directory", vim.log.levels.WARN)
            return true
        end
        configs.zlsp = zlsp_config(zoo_dir)
    end

    require("lspconfig").zlsp.setup(vim.tbl_deep_extend("force", {}, server_opts))

    -- The FileType autocmd created by setup() won't fire for buffers that
    -- are already open. Re-trigger FileType on matching buffers so zlsp
    -- attaches immediately.
    vim.schedule(function()
        local filetypes = { python = true, bzl = true, ["BUILD.bazel"] = true }
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and filetypes[vim.bo[buf].filetype] then
                vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
            end
        end
    end)

    return true
end

return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            servers = {
                ty = {
                    settings = {
                        ty = {
                            python = vim.fn.exepath("python"),
                        },
                    },
                },
                zlsp = {},
                pyright = {
                    mason = false,
                    autostart = false,
                },
            },
            setup = {
                zlsp = setup_zlsp,
            },
        },
    },
}
