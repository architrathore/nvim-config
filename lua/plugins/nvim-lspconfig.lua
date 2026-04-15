local zoolander = require("config.zoolander")

--- Build ty config, preferring the zoolander universe when present.
--- @return table
local function ty_config()
    local overlay_python = zoolander.ensure_ty_overlay()
    if not overlay_python then
        return {}
    end

    return {
        settings = {
            ty = {
                configuration = {
                    environment = {
                        -- Point ty at the cached overlay env so import
                        -- resolution uses the real universe but avoids the
                        -- incompatible uv-style pyvenv.cfg.
                        python = overlay_python,
                    },
                },
            },
        },
    }
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
        local zoo_dir = zoolander.find_root()
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
                ty = ty_config(),
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
