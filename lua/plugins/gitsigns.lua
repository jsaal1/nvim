return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            on_attach = function(bufnr)
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Navigation between hunks
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, "Next hunk")

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, "Previous hunk")

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk")
                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk")
                map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
                map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
                map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
                map("n", "<leader>htb", gitsigns.toggle_current_line_blame, "Toggle line blame")
            end,
        })
    end,
}
