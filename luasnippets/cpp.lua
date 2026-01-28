-- local ctor = s("ctor", c(1,
-- 	t("//default"),
-- 	t("// TODO: constructor")
-- ))
-- local op_plus = s("op+", t("// TODO: operator +"))
--
-- return { ctor, op_plus }

local find_class_node = function()
	local n = vim.treesitter.get_node()
	while n do
		if n:type() == "class_specifier" then
			break
		end
		n = n:parent()
	end
	return n
end

-- Find current class name
local current_class_name = function()
	local n = vim.treesitter.get_node()
	while n do
		if n:type() == "class_specifier" or n:type() == "struct_specifier" then
			break
		end
		n = n:parent()
	end
	if not n then
		return nil
	end
	for i = 0, n:named_child_count() - 1, 1 do
		local ch = n:named_child(i)
		if ch:type() == "type_identifier" then
			return vim.treesitter.get_node_text(ch, 0)
		end
	end
	return nil
end

local class_name = s(
	"$name",
	d(1, function(args)
		-- local q = vim.treesitter.query.parse([[
		-- (class_specifier name: (type_identifier) @n)
		-- ]])
		-- q:iter_
		local cn = current_class_name()
		if not cn then
			return sn(nil, { i(1, "Class"), t("::"), extras.rep(1), t({ "()", "{", "}" }) })
		end
		return sn(nil, { t(cn), t("("), i(1, ""), t(");") })
	end, {})
)

local simple_class_template = function(snip_id, tpl)
	return s(
		snip_id,
		d(1, function(args)
			local snip = tpl(current_class_name())
			if not snip then
				vim.notify("Invalid scope")
				return sn(nil, {})
			end
			return sn(nil, snip)
		end, {})
	)
end

local ctor = simple_class_template("$ctor", function(c)
	if c then
		return { t(c), t("("), i(1), t(");") }
	else
		return fmta(
			[[
			<>::<>(<>)
			{
			<>
			}
			]],
			{ i(1, "class_name"), extras.rep(1), i(2), i(0) }
		)
		-- return { i(1, "class_name"), t("::"), extras.rep(1), t("("), i(2), t({ ")", "{" }), i(0), t({ "", "}" }) }
	end
end)

local copy_ctor = simple_class_template("$cctor", function(c)
	if c then
		return { t(c), t("(const " .. c .. "& "), i(1, "other"), t(")") }
	else
		return {
			i(1, "class_name"),
			t("::"),
			extras.rep(1),
			t("(const "),
			extras.rep(1),
			t("& "),
			i(2, "other"),
			t({ ")", "{", "", "}" }),
		}
	end
end)

local move_ctor = simple_class_template("$mctor", function(c)
	if c then
		return { t(c), t("(" .. c .. "&& "), i(1, "other"), t(") noexcept") }
	else
		return {
			i(1, "class_name"),
			t("::"),
			extras.rep(1),
			t("("),
			extras.rep(1),
			t("&& "),
			i(2, "other"),
			t({ ") noexcept", "{", "", "}" }),
		}
	end
end)

local dtor = simple_class_template("$dtor", function(c)
	if c then
		return { t("~" .. c .. "()") }
	else
		return { i(1, "class_name"), t("::~"), extras.rep(1), t("("), i(2), t({ ")", "{", "", "}" }) }
	end
end)

local no_copy = simple_class_template("$non_copyable", function(c)
	if not c then
		return nil
	end
	return t({ c .. "(const " .. c .. "&) = delete;", c .. "& operator=(const " .. c .. "&) = delete;", "" })
end)

local no_move = simple_class_template("$non_movable", function(c)
	if not c then
		return nil
	end
	return { t({ c .. "(" .. c .. "&&) = delete;", c .. "& operator=(" .. c .. "&) = delete;", "" }) }
end)

return { ctor, copy_ctor, move_ctor, dtor, no_copy, no_move }
-- vim: ts=2 sts=2 sw=2 noet
