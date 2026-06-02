-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	-- Buffers tabline
	{
		"romgrk/barbar.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		keys = {
			{ "<F2>", "<cmd>BufferPrevious<CR>" },
			{ "<F14>", "<cmd>BufferMovePrevious<CR>" },
			{ "<F3>", "<cmd>BufferNext<CR>" },
			{ "<F15>", "<cmd>BufferMoveNext<CR>" },
			{ "<F4>", "<cmd>BufferDelete<CR>" },
			{ "<F16>", "<cmd>BufferPin<CR>" },
			{ "<F28>", "<cmd>BufferCloseAllButCurrentOrPinned<cr>" },
		},
		opts = {
			animation = false,
			auto_hide = 1,
			icons = {
				filetype = {
					enabled = false,
				},
			},
		},
	},
	-- Walk aroung using treesitter (C-hjkl, M-hjkl)
	--[[{
		"aaronik/treewalker.nvim",
		-- The following options are the defaults.
		-- Treewalker aims for sane defaults, so these are each individually optional,
		-- and setup() does not need to be called, so the whole opts block is optional as well.
		keys = {
			-- movement
			{ "<C-k>", "<cmd>Treewalker Up<cr>", mode = { "n", "v" }, silent = true },
			{ "<C-j>", "<cmd>Treewalker Down<cr>", mode = { "n", "v" }, silent = true },
			{ "<C-h>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, silent = true },
			{ "<C-l>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, silent = true },
			-- swapping
			{ "<M-k>", "<cmd>Treewalker SwapUp<cr>", silent = true },
			{ "<M-j>", "<cmd>Treewalker SwapDown<cr>", silent = true },
			{ "<M-h>", "<cmd>Treewalker SwapLeft<cr>", silent = true },
			{ "<M-l>", "<cmd>Treewalker SwapRight<cr>", silent = true },
		},
		opts = {
			-- Whether to briefly highlight the node after jumping to it
			highlight = true,

			-- How long should above highlight last (in ms)
			highlight_duration = 250,

			-- The color of the above highlight. Must be a valid vim highlight group.
			-- (see :h highlight-group for options)
			highlight_group = "CursorLine",
		},
	},]]
	-- Pretty status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
		opts = { winbar = {
			lualine_c = {
				{ "navic", color_correction = nil, navic_opts = nil },
			},
		} },
	},
	-- next/prev reference under cursor using LSP
	{
		"mawkler/refjump.nvim",
		event = "LspAttach", -- Uncomment to lazy load
		opts = {},
	},
	-- Git repo permalinks
	{
		"9seconds/repolink.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = {
			"RepoLink",
		},
		config = function()
			local repolink = require("repolink")
			repolink.setup({
				url_builders = {
					["gitlab.mvk.com"] = repolink.url_builder_for_gitlab("https://gitlab.mvk.com"),
					["gitlab.corp.mail.ru"] = repolink.url_builder_for_gitlab("https://gitlab.corp.mail.ru"),
					["git.p.ecnl.ru"] = repolink.url_builder_for_gitlab("https://git.p.ecnl.ru"),
				},
			})
		end,
		opts = {},
	},
	-- Comments
	{
		"numToStr/Comment.nvim",
		opts = {
			-- See .local/share/nvim/lazy/Comment.nvim/lua/Comment/init.lua
			toggler = {
				line = "<leader>x",
				block = "<leader>X",
			},
			opleader = {
				line = "<leader>x",
				block = "<leader>X",
			},
		},
	},
	-- Generate doxygen blocks
	{ "kkoomen/vim-doge", keys = {
		{ "<leader>cd", "<cmd>DogeGenerate<CR>", desc = "[C]ode [D]ocstring" },
	} },
	-- Highlight chunk beginning/end
	-- {
	-- 	"shellRaining/hlchunk.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	opts = {
	-- 		chunk = { enable = true },
	-- 	},
	-- },
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinLeave" },
	},
	-- Sudo read/write
	{
		"lambdalisue/vim-suda",
		lazy = false,
		config = function()
			vim.cmd([[
			let g:suda#executable='pwn'
			let g:suda_smart_edit=1
			let g:suda#noninteractive=1
			]])
		end,
	},
	-- Yank ring
	{
		"gbprod/yanky.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
			{ "<c-p>", "<Plug>(YankyPreviousEntry)" },
			{ "<c-n>", "<Plug>(YankyNextEntry)" },
			{
				"<leader>p",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				{ desc = "yanky [P]aste" },
			},
		},
		opts = {
			ring = {
				storage = "sqlite",
				sync_with_numbered_registers = false,
				storage_path = NV_tmp_dir("") .. "yanky.db",
			},
			system_clipboard = {
				sync_with_ring = false,
			},
			highlight = {
				on_put = true,
				on_yank = true,
				timer = 300,
			},
			textobj = {},
		},
	},
	-- Toggle comment visibility
	{
		"soemre/commentless.nvim",
		cmd = "Commentless",
		keys = {
			{
				"<leader>tc",
				function()
					require("commentless").toggle()
				end,
				desc = "[T]oggle [C]omments",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},
	-- Run commands for buffer
	{
		"https://codeberg.org/Ferhuce/run.nvim",
		opts = {
			keymaps = {
				rerun = "<C-r>",
			},
		},
	},
	-- Consider reviewing
	--   https://github.com/DmarshalTU/yaml-jumper (navigate yaml)
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("neogit").setup({})
			vim.cmd("hi clear DiffAdd")
			vim.cmd("hi clear NeogitDiffAdd")
			vim.cmd("hi clear NeogitDiffCursor")
			vim.cmd("hi clear NeogitDiffAddHighlight")
			vim.cmd("hi DiffAdd guibg=#103010")
			vim.cmd("hi NeogitDiffAdd guibg=#103010")
		end,
	},
	-- Moving windows around
	"sindrets/winshift.nvim",
	-- Add print statements for debugging
	{
		"andrewferrier/debugprint.nvim",
		event = "VeryLazy",
		opts = {
			filetypes = {
				["cpp"] = {
					display_location = false,
					display_snippet = false,
					left = 'do { fmt::print(stderr, "{}:{}  ',
					right = '\\n", __FILE__, __LINE__); fflush(stderr);',
					mid_var = '{}\\n", __FILE__, __LINE__',
					right_var = "); fflush(stderr); } while (0);",
				},
			},
		},
	},
	-- debug with UI
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		opts = { handlers = {} },
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	-- LaTeX support
	"lervag/vimtex",
	-- Interactive align
	{ "echasnovski/mini.align", version = "*", opts = {} },
	-- Surround
	{
		"kylechui/nvim-surround",
		version = "", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},
	-- Surround UI
	{
		"roobert/surround-ui.nvim",
		dependencies = {
			"kylechui/nvim-surround",
			"folke/which-key.nvim",
		},
		opts = { root_key = "S" },
	},
	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},
	-- Code actions with preview
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },

			-- optional picker via telescope
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		opts = {},
		keys = {
			{
				"<leader>ca",
				function()
					require("tiny-code-action").code_action()
				end,
				desc = "Code [A]ction vith preview",
				silent = true,
				remap = false,
			},
		},
	},
	-- Rainbow variables using LSP!!!
	--[[ {
		"goldos24/rainbow-variables-nvim",
		config = function()
			require("rainbow-variables-nvim")
		end,
	}, ]]
	-- Scratch buffer with calculator
	{
		"josephburgess/nvumi",
		dependencies = { "folke/snacks.nvim" },
		cmd = "Nvumi",
		opts = {
			virtual_text = "newline", -- or "inline"
			prefix = " >> ", -- prefix shown before the output
			date_format = "iso", -- or: "uk", "us", "long"
			keys = {
				run = "<CR>", -- run/refresh calculations
				reset = "R", -- reset buffer
				yank = "<leader>y", -- yank output of current line
				yank_all = "<leader>Y", -- yank all outputs
			},
			-- see below for more on custom conversions/functions
			custom_conversions = {},
			custom_functions = {},
		},
	},
	--
	{
		"atusy/treemonkey.nvim",
		keys = {
			{
				"m",
				function()
					require("treemonkey").select({
						ignore_injections = false,
						highlight = { backdrop = "LspInlayHint" },
					})
				end,
				mode = { "x", "o" },
				desc = "Set selection with treesitter",
			},
		},
	},
	-- NeoVIM tips
	{
		"saxon1964/neovim-tips",
		version = "*", -- Only update on tagged releases
		dependencies = {
			"MunifTanjim/nui.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			-- OPTIONAL: Location of user defined tips (default value shown below)
			user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
			-- OPTIONAL: Prefix for user tips to avoid conflicts (default: "[User] ")
			user_tip_prefix = "[User] ",
			-- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
			warn_on_conflicts = true,
			-- OPTIONAL: Daily tip mode (default: 1)
			-- 0 = off, 1 = once per day, 2 = every startup
			daily_tip = 1,
		},
		keys = {
			{ "<leader>nto", ":NeovimTips<CR>", desc = "Neovim tips" },
			{ "<leader>nte", ":NeovimTipsEdit<CR>", desc = "Edit your Neovim tips" },
			{ "<leader>nta", ":NeovimTipsAdd<CR>", desc = "Add your Neovim tip" },
			{ "<leader>ntr", ":NeovimTipsRandom<CR>", desc = "Show random tip" },
		},
	},
	-- Plugin store (registry)
	{
		"alex-popov-tech/store.nvim",
		dependencies = { "OXY2DEV/markview.nvim" },
		opts = {},
		cmd = "Store",
	},
	-- Snippets!
	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		keys = {
			{ "<C-k>", "<Plug>luasnip-expand-snippet", desc = "Expand snippet", mode = "i" },
		},
		config = function()
			require("luasnip.config").set_config({
				update_events = "TextChanged,TextChangedI",
				override_builtin = true,
			})
			require("luasnip.loaders.from_snipmate").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load()
		end,
	},
	-- LuaSnip telescope integartion
	{
		"benfowler/telescope-luasnip.nvim",
		config = function()
			require("telescope").load_extension("luasnip")
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 noet
