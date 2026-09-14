return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- the `main` rewrite does not support lazy-loading, and parsers must be
    -- rebuilt whenever the plugin updates
    lazy = false,
    build = ":TSUpdate",

    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- no-op for parsers that are already installed
        treesitter.install({
            "json",
            "yaml",
            "toml",
            "markdown",
            "markdown_inline",
            "bash",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "c",
            "cpp",
            "python",
            "make",
            "cmake",
            "regex",
            "latex",
            "bibtex",

            -- web languages: needed for nvim-ts-autotag, and previously
            -- installed on the master branch
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",

            "csv",
            "fish",
            "gitignore",
        })

        -- `main` ships only parsers and queries; highlighting and indentation
        -- are Neovim features we have to turn on per filetype ourselves.
        local no_indent = { c = true, cpp = true }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
            callback = function(ev)
                local lang = vim.treesitter.language.get_lang(ev.match)
                if not lang then
                    return
                end

                -- no parser installed for this filetype
                local ok, added = pcall(vim.treesitter.language.add, lang)
                if not ok or not added then
                    return
                end

                vim.treesitter.start(ev.buf, lang)

                if not no_indent[lang] then
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
