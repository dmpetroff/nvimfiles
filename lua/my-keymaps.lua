-- exit from insert mode
vim.keymap.set("i", "jj", "<ESC>")

vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Goto next error", silent = true })

vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Goto next error", silent = true })

-- Tabline keymaps (attach it to the plugin?)
-- vim.keymap.set("n", "<F2>", "<cmd>BufferPrevious<CR>")
-- vim.keymap.set("n", "<F14>", "<cmd>BufferMovePrevious<CR>")
-- vim.keymap.set("n", "<F3>", "<cmd>BufferNext<CR>")
-- vim.keymap.set("n", "<F15>", "<cmd>BufferMoveNext<CR>")
-- vim.keymap.set("n", "<F4>", "<cmd>BufferDelete<CR>")
-- vim.keymap.set("n", "<F16>", "<cmd>BufferPin<CR>")

-- tree walker
-- movement
-- vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
-- vim.keymap.set({ "n", "v" }, "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
-- vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
-- vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })

-- swapping
-- vim.keymap.set("n", "<M-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
-- vim.keymap.set("n", "<M-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
-- vim.keymap.set("n", "<M-h>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
-- vim.keymap.set("n", "<M-l>", "<cmd>Treewalker SwapRight<cr>", { silent = true })

require("nvim-treesitter.configs").setup({
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				-- You can also use captures from other query groups like `locals.scm`
				["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
			},
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true or false
			include_surrounding_whitespace = true,
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- vim: ts=2 sts=2 sw=2 et
