return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
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
			},

			sync_install = false,
			auto_install = false,

			highlight = {
				enable = true,
			},

			indent = {
				enable = true,
			},

			autotag = {
				enable = true,
			},
		})
	end,
}
