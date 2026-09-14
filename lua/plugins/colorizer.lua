return {
    "catgoose/nvim-colorizer.lua",
    name = "nvim-colorizer-catgoose",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        user_default_options = {
            names = false,
            mode = "background",
        },
    },
}
