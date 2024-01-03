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

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua git_files<CR>", { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fa", "<cmd>FzfLua files<CR>", { desc = "[F]ind [A]ll files" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands<CR>", { desc = "[F]ind [C]ommands" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines<CR>", { desc = "[F]ind [L]ine" })
vim.keymap.set("n", "<leader>f/", "<cmd>FzfLua blines<CR>", { desc = "[F]ind [/]earch" })

-- Down/Up with centering
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true })
