return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        lazygit = { enabled = true },

        -- inline image rendering for ipynb.nvim / markdown. Needs a terminal
        -- that speaks the kitty graphics protocol (kitty, wezterm, ghostty) —
        -- iTerm2 will not display these.
        image = { enabled = true },

        -- vim.ui.input / vim.ui.select, replacing the archived dressing.nvim
        input = { enabled = true },
        picker = { enabled = true },
    },
    keys = {
        {
            "<leader>tt",
            function()
                Snacks.terminal()
            end,
            desc = "Toggle Terminal",
        },
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },
        {
            "<leader>gl",
            function()
                Snacks.lazygit.log()
            end,
            desc = "Lazygit log (cwd)",
        },
    },
}
