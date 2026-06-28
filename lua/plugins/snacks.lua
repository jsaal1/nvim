return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        lazygit = { enabled = true },
    },
    keys = {
        { "<leader>gg", function() Snacks.lazygit() end,     desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
    },
}
