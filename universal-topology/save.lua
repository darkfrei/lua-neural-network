--	(c) darkfrei, 2020-08-02
--	MIT License

--	use as "save (tabl, filename)"
--	save (tabl, 'test.tabl')

function format_index_and_value (i, v)
	local str = ''
	-- format index
	if type (i) == "string" then
		if string.find(i, "-") then
			str = '["' .. i .. '"] = '
		else
			str = i .. ' = '
		end
	else
		str = '[' .. i .. '] = '
	end
	--format value
	if type (v) == 'number' then
		str = str .. v
	elseif type (v) == 'string' then
		str = str .. '"' .. v .. '"'
	else -- table
		str = str .. deep_to_str (v)
	end
	return str
end

function deep_to_str (tabl)
	local str = '{'
	for i, v in pairs (tabl) do
		str = str .. format_index_and_value (i, v) .. ', '
	end
	if #str > 2 then str = string.sub(str, 1, -3) end -- delete last comma and space
	str = str .. '}'
	return str
end

function save (tabl, filename)
	local new_line = string.char(10)
	local tab = '	'
	local str = 'return' .. new_line .. '{'
	for i, v in pairs (tabl) do
		if type (v) == "table" then
			str = str .. new_line .. tab .. deep_to_str (v) .. ','
		end
	end
	
	str = string.sub(str, 1, -2) -- delete last comma
	str = str .. new_line .. '}'
	
	file = io.open(filename, "w" )
	file:write( str )
	file:close()
end

-- test

local tabl = 
{
	{1, 2, 3},
	{"a", "b", "c"},
	{b = 2, a = 1, c = {1, 2, 3, {4, 5, 6}, b = "b", d = {["a-b"] = 117}, a = "a", c = {1, 2, 3, list = {1, 2, 3, "a-b"}}}}
}

--save (tabl, 'test.tabl')







































































