return {
	"ajbucci/ipynb.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
		"folke/snacks.nvim", -- for inline image rendering
		-- "nvim-tree/nvim-web-devicons", -- optional, for language icons in cell borders
	},
	opts = {},
	config = function(_, opts)
		-- ipynb.nvim registers its bundled tree-sitter parser on the wrong
		-- table (`parsers.ipynb` instead of `parsers.list.ipynb`), so
		-- nvim-treesitter can never find it and auto-install throws
		-- "Parser not available for language 'ipynb'". Register it
		-- correctly ourselves before ipynb.nvim's own (broken) attempt.
		-- Also: it uses install_info.path, but nvim-treesitter's installer
		-- expects install_info.url (a local dir is fine) plus a `files`
		-- list of the sources to compile.
		local util_ok, util = pcall(require, "ipynb.util")
		local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if util_ok and parsers_ok then
			parsers.get_parser_configs().ipynb = {
				install_info = {
					url = util.get_plugin_root() .. "/tree-sitter-ipynb",
					files = { "src/parser.c", "src/scanner.c" },
				},
			}
		end
		require("ipynb").setup(opts)
	end,
}

