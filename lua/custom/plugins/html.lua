local dbg = function(s)
	vim.api.nvim_put({ s .. "; " }, "", true, true)
end

local my_close_tag = function()
	local ok, buf_parser = pcall(vim.treesitter.get_parser)
	if not ok then
		return
	end
	buf_parser:parse(true)
	-- find element node
	local n = vim.treesitter.get_node()
	if n == nil then
		return
	end
	if n:type() ~= "element" or n:named_child_count() < 1 then
		return
	end
	n = n:named_child(0)
	if n:type() ~= "start_tag" or n:named_child_count() < 1 then
		return
	end
	local tag_name = vim.treesitter.get_node_text(n:named_child(0), 0)
	vim.api.nvim_put({ string.format("</%s>", tag_name) }, "", true, true)
end

return {
	{
		"windwp/nvim-ts-autotag",
		filetype = { "html" },
		keys = {
			{
				"<C-_>",
				function()
					my_close_tag()
				end,
				mode = "i",
				desc = "Close HTML tag",
				ft = "html",
			},
		},
		opts = {
			opts = { enable_close = false },
		},
	},
}
-- vim: ts=2 sts=2 sw=2 noet
