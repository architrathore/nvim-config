-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local copy_osc52 = require("vim.ui.clipboard.osc52").copy("+")

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Sync yanks to the local clipboard over OSC52",
    callback = function()
      if vim.v.event.operator ~= "y" or vim.v.event.regname == "_" then
        return
      end

      copy_osc52(vim.v.event.regcontents, vim.v.event.regtype)
    end,
  })
end
