-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<leader>ff"] = false,
            },
            n = {
                ["<leader>ff"] = false,
            },
        },
    },
})
--   Warn  09:35:02 notify.warn [Fzf-lua] `git status` took 8 seconds, consider using `:FzfLua files git_icons=false` in this repository.

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua git_files git_icons=false<CR>", { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua files git_icons=false<CR>", { desc = "[F]ind [A]ll files" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers git_icons=false<CR>", { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep git_icons=false<CR>", { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands git_icons=false<CR>", { desc = "[F]ind [C]ommands" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags git_icons=false<CR>", { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines git_icons=false<CR>", { desc = "[F]ind [L]ine" })
vim.keymap.set("n", "<leader>f/", "<cmd>FzfLua blines git_icons=false<CR>", { desc = "[F]ind [/]earch" })

-- Down/Up with centering
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Copy file content to clipboard
vim.api.nvim_set_keymap("n", "<leader>yf", "<cmd>%y+<CR>", { noremap = true, desc = "[Y]ank [F]ile" })
