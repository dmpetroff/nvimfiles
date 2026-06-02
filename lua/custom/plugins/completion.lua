local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_tab_mapping = function(cmp, luasnip)
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			if #cmp.get_entries() == 1 then
				cmp.confirm({ select = true })
			else
				cmp.select_next_item()
			end

		--[[
      -- This would trigger completion menu if tab was pressed in the middle of
      -- the word, but this is what I really hate
		elseif has_words_before() then
			cmp.complete()
			if #cmp.get_entries() == 1 then
				cmp.confirm({ select = true })
			end
      ]]
		elseif luasnip.locally_jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	end, { "i", "s" })
end

local cmp_s_tab_mapping = function(cmp, luasnip)
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" })
end

local cmp_cr_mapping = function(cmp, luasnip)
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			if luasnip.expandable() then
				luasnip.expand()
			else
				cmp.confirm({
					select = true,
				})
			end
		else
			fallback()
		end
	end)

	-- return cmp.mapping({
	-- 	i = function(fallback)
	-- 		if cmp.visible() and cmp.get_active_entry() then
	-- 			cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
	-- 		else
	-- 			fallback()
	-- 		end
	-- 	end,
	-- 	s = cmp.mapping.confirm({ select = true }),
	-- 	c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
	-- })
end

---@module "lazy"
---@type LazySpec
return {
	"saghen/blink.cmp",
	--build = "cargo build --release",
	version = "1.*",
	dependencies = {
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		snippets = { preset = "luasnip" },
		fuzzy = {
			implementation = "rust",
			-- sorts = {
			-- 	"exact",
			-- 	-- defaults
			-- 	"score",
			-- 	"sort_text",
			-- },
		},
		completion = {
			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
		},
		keymap = {
			preset = "super-tab",
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "insert_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "insert_prev", "snippet_backward", "fallback" },
			-- ["<C-Right>"] = { "snippet_forward", "fallback" },
			-- ["<C-Left>"] = { "snippet_backward", "fallback" },
			["<C-k>"] = {
				function(cmp) -- this stuff doesn't work
					if cmp.snippet_active() then
						return cmp.accept()
					end
				end,
			},
		},
	},
	sources = {
		providers = {
			-- don't offer snippets if invoked by trigger character
			snippets = {
				should_show_items = function(ctx)
					return ctx.trigger.initial_kind ~= "trigger_character"
				end,
			},
			-- lsp = {
			-- 	name = "LSP",
			-- 	module = "blink.cmp.sources.lsp",
			-- 	transform_items = function(_, items)
			-- 		return vim.tbl_filter(function(item)
			-- 			return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
			-- 		end, items)
			-- 	end,
			-- },
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
