-- nvim-treesitter has no `autotag` module, so configuring this through
-- `nvim-treesitter.configs` silently did nothing; it needs its own setup().
return {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
}
