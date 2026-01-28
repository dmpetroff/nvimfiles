local frame_filetype_chars = {
	c = { "//", "-", "//" },
	cpp = { "//", "-", "//" },
	make = { "#", "#", "#" },
	sh = { "#", "#", "#" },
	lua = { "--", "-", "--" },
}

local F = function(x)
	return f(function(args, snip)
		local c = frame_filetype_chars[vim.bo.filetype] or { "#", "#", "#" }
		return x(args[1][1], c)
	end, { 1 })
end

local box_line = function(a, c)
	return c[1] .. string.rep(c[2], 2 + vim.fn.strchars(a)) .. c[3]
end

local box_ch = function(n)
	return F(function(a, c)
		return c[n]
	end)
end

local box_ = s("box", {
	-- top line
	F(box_line),
	t({ "", "" }),
	-- middle
	box_ch(1),
	t(" "),
	i(1, "zzz"),
	t(" "),
	box_ch(3),
	t({ "", "" }),
	-- bottom
	F(box_line),
	t({ "", "" }),
})

local box = s("box", {
	f(function(args, _)
		local t = {}
		for _, line in ipairs(args[1]) do
			table.insert(t, "> " .. line)
		end
		return t
	end, { 1 }),
	t({ "", "" }),
	i(1, "default"),
	t({ "-------", "" }),
	f(function(args, _)
		return tostring(#args[1][1])
	end, { 1 }),
})

return { box }
-- vim: set ft=lua
