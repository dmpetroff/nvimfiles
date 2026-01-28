return {
	{
		"nvim-compc",
		dir = "~/tools/nvim-compc",
		lazy = false,
		dev = true,
		keys = {
			{
				"<F9>",
				function()
					vim.cmd("Compc")
					vim.cmd("write")
					vim.cmd("make")
				end,
				mode = { "n", "i" },
				desc = "Compile current file using compile_command.json",
			},
		},
		opts = {},
	},
	-- Generate C++ method definition
	{
		"DanielMSussman/simpleCppTreesitterTools.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = "cpp",
		keys = {
			{ "<leader>cI", "<cmd>ImplementMembersInClass<cr>", desc = "[I]mplement class member decls", ft = "cpp" },
			{
				"<leader>cl",
				"<cmd>ImplementMemberOnCursorLine<cr>",
				desc = "Implement member on current [l]ine",
				ft = "cpp",
			},
			{ "<leader>cr", "<cmd>CreateDerivedClass<cr>", desc = "Create de[r]ived class", ft = "cpp" },
		},
		opts = {},
	},
	-- Open alternate file
	{ "vim-scripts/a.vim" },
	-- Extended clangd features
	{ "p00f/clangd_extensions.nvim" },
}

-- vim: ts=2 sts=2 sw=2 noet
