return {
    "echasnovski/mini.move",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        mappings = {
            -- Move visual selection
            left = "<M-h>",
            right = "<M-l>",
            down = "<M-j>",
            up = "<M-k>",

            -- Move current line
            line_left = "<M-h>",
            line_right = "<M-l>",
            line_down = "<M-j>",
            line_up = "<M-k>",
        },
    },
}
