return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	config = function()
		-- Pin generated-parser ABI to 14 so the Mason-installed tree-sitter CLI
		-- (pinned at v0.24.7, which still accepts --no-bindings used by
		-- nvim-treesitter master) can satisfy parsers that need regeneration
		-- from grammar.js. nvim 0.12 accepts ABI 13–15.
		require("nvim-treesitter.install").ts_generate_args =
			{ "generate", "--no-bindings", "--abi", 14 }

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
				"latex",
				"bibtex",
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
