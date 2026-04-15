local M = {}

local host_type_file = "/pay/conf/host_type"

local function sorted_matches(base, pattern)
    local matches = vim.fn.globpath(base, pattern, false, true)
    if not matches or vim.tbl_isempty(matches) then
        return {}
    end

    table.sort(matches)
    return matches
end

function M.get_host_type()
    if vim.fn.filereadable(host_type_file) ~= 1 then
        return nil
    end

    local ok, lines = pcall(vim.fn.readfile, host_type_file)
    if not ok or not lines or #lines == 0 then
        return nil
    end

    local host_type = vim.trim(lines[1] or "")
    if host_type == "" then
        return nil
    end

    return host_type
end

function M.is_remote()
    return M.get_host_type() ~= nil
end

--- Resolve the local Zoolander checkout across laptop and remote layouts.
--- @return string|nil
function M.find_root()
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

function M.find_universe_python(zoo_dir)
    zoo_dir = zoo_dir or M.find_root()
    if not zoo_dir then
        return nil
    end

    for _, python in ipairs(sorted_matches(zoo_dir, "py_universe_*/bin/python")) do
        if vim.fn.filereadable(python) == 1 then
            return python
        end
    end

    return nil
end

local function universe_dir(venv_python)
    if not venv_python or venv_python == "" then
        return nil
    end

    return vim.fn.fnamemodify(venv_python, ":h:h")
end

local function write_overlay_symlinks(source_dir, overlay_dir)
    local ok, entries = pcall(vim.fn.readdir, source_dir)
    if not ok or not entries then
        return false
    end

    for _, entry in ipairs(entries) do
        if entry ~= "pyvenv.cfg" then
            local target = source_dir .. "/" .. entry
            local link = overlay_dir .. "/" .. entry
            local success = vim.uv.fs_symlink(target, link)
            if not success then
                return false
            end
        end
    end

    if vim.fn.filereadable(overlay_dir .. "/lib64") ~= 1 and vim.fn.isdirectory(overlay_dir .. "/lib64") ~= 1 then
        vim.uv.fs_symlink("lib", overlay_dir .. "/lib64")
    end

    return true
end

function M.ty_overlay_dir()
    return vim.fn.stdpath("cache") .. "/ty/zoolander-env"
end

--- ty 0.0.30 still rejects Zoolander's uv-style `pyvenv.cfg` because it omits
--- the `home` key. Build a cached overlay env that reuses the real universe
--- contents but writes a compatible `pyvenv.cfg` for ty to consume.
--- @param venv_python string
--- @return string|nil
function M.write_ty_overlay(venv_python)
    local source_dir = universe_dir(venv_python)
    if not source_dir then
        return nil
    end

    local overlay_dir = M.ty_overlay_dir()
    local overlay_python = overlay_dir .. "/bin/python"
    local real_python = vim.fn.resolve(venv_python)
    local python_home = vim.fn.fnamemodify(real_python, ":h")
    if python_home == "" then
        return nil
    end

    vim.fn.delete(overlay_dir, "rf")
    vim.fn.mkdir(overlay_dir, "p")
    if not write_overlay_symlinks(source_dir, overlay_dir) then
        vim.fn.delete(overlay_dir, "rf")
        return nil
    end

    local pyvenv_cfg = source_dir .. "/pyvenv.cfg"
    local lines = { "home = " .. python_home }
    if vim.fn.filereadable(pyvenv_cfg) == 1 then
        local ok, existing_lines = pcall(vim.fn.readfile, pyvenv_cfg)
        if ok and existing_lines then
            for _, line in ipairs(existing_lines) do
                if not line:match("^home%s*=") then
                    table.insert(lines, line)
                end
            end
        end
    end
    vim.fn.writefile(lines, overlay_dir .. "/pyvenv.cfg")

    if vim.fn.executable(overlay_python) ~= 1 then
        vim.fn.delete(overlay_dir, "rf")
        return nil
    end

    return overlay_python
end

--- @return string|nil
function M.ensure_ty_overlay()
    return M.write_ty_overlay(M.find_universe_python())
end

return M
