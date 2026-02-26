-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- require("telescope").setup({
--     defaults = {
--         mappings = {
--             i = {
--                 ["<leader>ff"] = false,
--             },
--             n = {
--                 ["<leader>ff"] = false,
--             },
--         },
--     },
-- })

-- vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua git_files git_icons=false<CR>", { desc = "[F]ind [F]iles" })
-- vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua files git_icons=false<CR>", { desc = "[F]ind [A]ll files" })
-- vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers git_icons=false<CR>", { desc = "[F]ind [B]uffer" })
-- vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep git_icons=false<CR>", { desc = "[F]ind by [G]rep" })
-- vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands git_icons=false<CR>", { desc = "[F]ind [C]ommands" })
-- vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags git_icons=false<CR>", { desc = "[F]ind [H]elp" })
-- vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines git_icons=false<CR>", { desc = "[F]ind [L]ine" })
-- vim.keymap.set("n", "<leader>f/", "<cmd>FzfLua blines git_icons=false<CR>", { desc = "[F]ind [/]earch" })

-- Down/Up with centering
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Copy entire file content to clipboard
vim.api.nvim_set_keymap("n", "<leader>yf", "<cmd>%y+<CR>", { noremap = true, desc = "[Y]ank [F]ile" })

-- Yank file name + line number
vim.keymap.set("n", "<leader>yl", function()
    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end

    local relative_file = vim.fn.fnamemodify(file, ":.")

    local line = vim.api.nvim_win_get_cursor(0)[1]
    local location = string.format("%s:%d", relative_file, line)
    vim.fn.setreg("+", location)
    vim.notify("Copied: " .. location, vim.log.levels.INFO)
end, { desc = "[Y]ank Fi[L]e name + line number" })

-- Select all
vim.api.nvim_set_keymap("n", "<leader>sf", "ggVG", { noremap = true, desc = "[S]elect [A]ll" })

vim.keymap.set("n", "<leader>ga", function()
    local file = vim.fn.expand("%:p")
    local cmd = string.format('git add -N "%s"', file)
    local output = vim.fn.system(cmd)
    if vim.v.shell_error == 0 then
        vim.notify("File added to Git tracking", vim.log.levels.INFO)
    else
        vim.notify("Failed to add file to Git tracking: " .. output, vim.log.levels.ERROR)
    end
end, { desc = "Git Add Current File" })

-- Enable/disable Copilot
vim.keymap.set("n", "<leader>ct", "<cmd>Copilot toggle<CR>", { desc = "[C]opilot [T]oggle" })

-- Quality of life
vim.keymap.set("n", "<C-c>", "ciw", { desc = "Change Inner Word" })
vim.keymap.set("n", "<C-p>", function()
    vim.cmd.normal("yy")
    vim.cmd.normal("gcc")
    vim.cmd.normal("p")
end, { desc = "Comment and duplicate line" })
