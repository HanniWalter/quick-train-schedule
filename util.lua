--utils



function get_table_length(table)
	local index = 0
	for _,k in pairs(table) do
		index = index + 1
	end
	return index
end

function combine_tables(table1, table2)
	for key,val in pairs(table2) do
		if type(key) ~= "number" then
			table1[key] = val
		else
			table.insert(table1, val)
		end
	end
	return table1
end

function print(...)
	local args = {...}
	if #args == 1 then
		game.print(args[1])
		return
	end
	local pStr = ""
	for _,s in pairs(args) do
		s = s..tostring(s).."  "
	end
	game.print(pStr)
end

--train stuff

function show_flying_text(train, text, color, altOffset)
	local offset = 0
	if altOffset then
		offset = altOffset
	end

	local center = 1 + math.floor(#train.carriages / 2)

	local position = train.carriages[center].position
	position.y = position.y + offset
	train.carriages[1].surface.create_entity({name="flying-text", position=position, text=text, color=color})
end

function has_train_temp_stop(train)
	for _,record in pairs(train.schedule.records) do 
		if record.temporary then return true end
	end
	return false
end

