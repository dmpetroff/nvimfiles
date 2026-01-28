return {
	{
		"edeneast/nightfox.nvim",
		priority = 1000,
		enabled = false,
		config = function()
			require("nightfox").setup({
				options = {
					styles = {
						keywords = "italic",
					},
				},
				palettes = {
					nordfox = {},
				},
			})
			vim.cmd.colorscheme("nordfox")
		end,
	},
	-- nice color theme
	-- {
	-- 	"uhs-robert/oasis.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	dependencies = {
	-- 		"nvim-lualine/lualine.nvim",
	-- 	},
	-- 	config = function()
	-- 		--vim.cmd.colorscheme("oasis-lagoon") -- or use a variant like ("oasis_desert")
	-- 		require("oasis").setup({
	-- 			style = "lagoon",
	-- 		})
	-- 		require("lualine").setup({
	-- 			options = {
	-- 				theme = "oasis", -- Automatically matches your current Oasis palette
	-- 			},
	-- 		})
	-- 		--[[
	-- 		remaps = {
	-- 			-- function calls
	-- 			"@function",
	-- 			-- namespace
	-- 			"@module",
	-- 			"@lsp.type.namespace.cpp",
	-- 			-- types
	-- 			"@type",
	-- 			"@lsp.type.class",
	-- 			{ "@type.builtin", "Statement" },
	-- 			-- args
	-- 			"@variable.parameter",
	-- 			"@lsp.type.parameter",
	-- 			-- class members
	-- 			"@property.cpp",
	-- 			"@lsp.type.property.cpp",
	-- 			-- operators
	-- 			{ "@operator", "@punctuation.delimiter", "@punctuation.bracket" },
	-- 			{ "@lsp.typemod.operator.userDefined", "@lsp.type.macro" },
	-- 			-- global variables
	-- 			{ "@lsp.typemod.variable.fileScope.cpp", "Identifier" },
	-- 		}
	-- 		for i, n in pairs(remaps) do
	-- 			if type(n) == "table" then
	-- 				for k = 1, #n - 1 do
	-- 					vim.api.nvim_set_hl(0, n[k], { link = n[#n] })
	-- 				end
	-- 			else
	-- 				vim.api.nvim_set_hl(0, n, { link = "Normal" })
	-- 			end
	-- 		end
	-- 		]]
	-- 	end,
	-- },
	{
		"uhs-robert/oasis.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local dfl = "Identifier"
			local highlight_overrides = {}
			local fg = function(cl)
				return { fg = cl }
			end
			remaps = {
				-- function calls
				"@function",
				"@variable",
				-- namespace
				"@module",
				"@lsp.type.namespace.cpp",
				-- types
				"@type",
				"@lsp.type.class",
				{ "@type.builtin", "Statement" },
				-- args
				"@variable.parameter",
				"@lsp.type.parameter",
				-- class members
				"@property.cpp",
				"@lsp.type.property.cpp",
				{ "@constant", "@constant.builtin", "@number", "boolean", "String" },
				{ "Comment", fg("#87ceeb") },
				{ "Preproc", fg("#cd5c5c") },
				{ "String", fg("#ffa0a0") },
				-- { "Statement", "Conditional" },
				{ "Conditional", { fg = "#bdb76b", bold = true } },
				{ "@keyword.directive", "Preproc" },
				-- operators
				{ "@operator", "@punctuation.delimiter", "@punctuation.bracket" },
				{ "@lsp.typemod.operator.userDefined", "@lsp.type.macro" },
				-- pretty
				{ "@variable.builtin", "@keyword.operator", "Statement" },
				{ "@lsp.type.macro", "Constant" },
				{ "@string.escape", fg("#ffdead") },
				-- global variables
				{ "@lsp.typemod.variable.fileScope", fg("#8080e0") },
				{ "@lsp.typemod.variable.globalScope", fg("#b050b0") },
			}
			highlight_overrides["Identifier"] = { fg = "#c1c8d1" }
			-- highlight_overrides["Identifier"] = { fg = "#cccccc" }
			for i, n in pairs(remaps) do
				if type(n) == "table" then
					for k = 1, #n - 1 do
						highlight_overrides[n[k]] = n[#n]
					end
				else
					highlight_overrides[n] = dfl
				end
			end
			require("oasis").setup({
				style = "lagoon", -- Optional: Choose any style like `lagoon` or 'dune'.
				palette_overrides = {
					oasis_lagoon = {
						bg = { core = "#000000" },
					},
				},
				highlight_overrides = highlight_overrides,
			})
		end,
	},
	{
		"ramojus/mellifluous.nvim",
		enabled = false,
		config = function()
			require("mellifluous").setup({}) -- optional, see configuration section.
			vim.cmd("colorscheme mellifluous")
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 noet
