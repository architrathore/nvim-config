return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            direction = "float",
        })
    end,
    keys = {
        { "<leader>tt", ":ToggleTerm<CR>", desc = "[T]oggle [T]erminal" },
    },
}
