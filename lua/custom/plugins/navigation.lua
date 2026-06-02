return {
	--[[
	{
		"cbochs/grapple.nvim",
		opts = {
			scope = "git", -- also try out "git_branch"
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
			{ "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			{ "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
		},
	}, ]]
	-- An interesting symbol explorer and more
	--[[
	{
		"bassamsdata/namu.nvim",
		opts = {
			global = {},
			namu_symbols = { -- Specific Module options
				options = {},
			},
		},
	}, ]]
	-- per-project bookmarks
	{
		"y3owk1n/warp.nvim",
		event = "VeryLazy",
		cmd = {
			"WarpAddFile",
			"WarpAddOnScreenFiles",
			"WarpDelFile",
			"WarpMoveTo",
			"WarpShowList",
			"WarpClearCurrentList",
			"WarpClearAllList",
			"WarpGoToIndex",
		},
		opts = {},
		keys = {
			{ "<leader>mm", "<cmd>WarpShowList<cr>", mode = "n", silent = true, desc = "Show bookmark list" },
			{ "<leader>ma", "<cmd>WarpAddFile<cr>", mode = "n", silent = true, desc = "Add to boomarks" },
			{ "<leader>md", "<cmd>WarpDelFile<cr>", mode = "n", silent = true, desc = "Remove from bookmarks" },
			-- {"ma", "<cmd><cr>", mode="n", silent=true, desc = ""},
		},
	},
	-- acejump-like navigation using
	{
		"smoka7/hop.nvim",
		version = "*",
		event = "VimEnter",
		keys = {
			{ "\\", "<cmd>HopWordMW<cr>", mode = { "n", "v" } },
			--{ "|", "<cmd>HopLine<cr>", mode = { "n", "v" } },
			{ "|", "<cmd>HopChar1MW<cr>", mode = { "n", "v" } },
		},
		opts = {
			-- keys = "etovxqpdygfblzhckisuran",
			keys = "edrftgqazxcvb",
		},
	},
	-- Execute action in new place (using hop) and then jump back
	{
		"Weissle/easy-action",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		keys = {
			{
				"<leader>e",
				"<cmd>BasicEasyAction<cr>",
				desc = "Execute command using hop",
				silent = true,
				remap = false,
			},
		},
		opts = {},
	},
	-- Make ; repeat last motion
	{
		"mawkler/demicolon.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {},
	},
	-- window navigation https://github.com/yorickpeterse/nvim-window
	{
		"yorickpeterse/nvim-window",
		keys = {
			{
				"<M-w>",
				function()
					require("nvim-window").pick()
				end,
				mode = { "i", "n" },
				desc = "Jump to window",
			},
		},
		opts = {},
	},
	-- see https://www.josean.com/posts/nvim-treesitter-and-textobjects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		main = "nvim-treesitter.configs",
		opts = {
			textobjects = {
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						-- ["]]"] = { query = "@class.outer", desc = "Next class start" },
						--
						-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
						["]o"] = "@loop.*",
						-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
						--
						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						-- ["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
					-- Below will go to either the start or the end, whichever is closer.
					-- Use if you want more granular movements
					-- Make it even more gradual by adding multiple queries and regex.
					goto_next = {
						["]d"] = "@conditional.outer",
					},
					goto_previous = {
						["[d"] = "@conditional.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner", -- swap parameters/argument with next
						["<leader>nm"] = "@function.outer", -- swap function with next
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner", -- swap parameters/argument with prev
						["<leader>pm"] = "@function.outer", -- swap function with previous
					},
				},
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

						["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

						["am"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},
						["im"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},

						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},
				},
			},
		},
	},
	-- Allow opening files with line number
	{
		"lewis6991/fileline.nvim",
		lazy = false,
	},
}
-- vim: ts=2 sts=2 sw=2 et
