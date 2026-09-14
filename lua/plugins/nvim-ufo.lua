return {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
        -- ufo takes over folding, so folds need to start open and the
        -- gutter needs room to show them
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        local ufo = require("ufo")

        ufo.setup({
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
        })

        local keymap = vim.keymap

        keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
        keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
        keymap.set("n", "zK", function()
            if not ufo.peekFoldedLinesUnderCursor() then
                vim.lsp.buf.hover()
            end
        end, { desc = "Peek folded lines or hover" })
    end,
}
