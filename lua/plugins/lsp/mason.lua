return {
    "mason-org/mason.nvim",
    dependencies = {
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        local mason_tool_installer = require("mason-tool-installer")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- lspconfig.lua enables every server explicitly (with blink's
            -- capabilities). Leaving this on additionally starts a server for
            -- any installed package that happens to have an lspconfig entry —
            -- e.g. `stylua --lsp`, which we only want as a conform formatter.
            automatic_enable = false,

            -- list of servers for mason to install
            ensure_installed = {
                "lua_ls",
                "pyright",
                "bashls",
                "jsonls",
                "yamlls",
                "taplo",
                "texlab",
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "black",
                "isort",
                "clang-format",
                "shfmt",
                "taplo",
                "latexindent",
            },
            auto_update = false,
            run_on_start = true,
        })
    end,
}
