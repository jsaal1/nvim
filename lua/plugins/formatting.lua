return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },

                python = { "black", "isort" },

                c = { "clang_format" },
                cpp = { "clang_format" },

                sh = { "shfmt" },
                bash = { "shfmt" },

                json = { "prettier" },
                yaml = { "prettier" },
                toml = { "taplo" },

                markdown = { "prettier" },

                tex = { "latexindent" },
            },

            format_on_save = {
                lsp_format = "fallback",
                async = false,
                timeout_ms = 1000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_format = "fallback",
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range" })
    end,
}
