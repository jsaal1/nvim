return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            -- load the Neovim runtime docs when editing this config
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}
