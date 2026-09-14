return {
    "lewis6991/satellite.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        handlers = {
            cursor = { enable = true },
            search = { enable = true },
            diagnostic = { enable = true },
            gitsigns = { enable = true },
            marks = { enable = true },
            quickfix = { enable = true },
        },
    },
}
