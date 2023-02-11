-------------------------------------------------------------------------------
--Mod by HanniWalter
-------------------------------------------------------------------------------

require "util"

function get_refulling_station_name(train)
	local returner = "Refuel "
	local carriages = train.carriages
	for _,car in pairs(carriages) do 
		if car.type == "locomotive" then
			returner = returner.."L"
		else
			returner = returner.."C"
		end
	end
	returner = returner..""
	return returner
end



function get_schedule_with_refueling(train)
	local current = train.schedule.current
	local FuelTrainScheduleRecord = {}
	FuelTrainScheduleRecord.station=get_refulling_station_name(train)
	FuelTrainScheduleRecord.wait_conditions = {{compare_type="or",type = "inactivity",ticks = 60}}
	FuelTrainScheduleRecord.temporary = true
	local records = train.schedule.records
	table.insert(records,current+1,FuelTrainScheduleRecord)
	local returner = {}
	returner.current = current
	returner.records = records
	return returner
end

function create_new_shedule(train,item_name) 
	if item_name == "" then
		local ProductRecord = {}
		ProductRecord.station="production"
		ProductRecord.wait_conditions = {{compare_type="or",type = "full"}}
		local EductRecord = {}
		EductRecord.station="eduction"
		EductRecord.wait_conditions = {{compare_type="or",type = "empty"}}
		return {current = 1,records ={ProductRecord,EductRecord}}
	end
		local ProductRecord = {}
		ProductRecord.station="production "..item_name
		ProductRecord.wait_conditions = {{compare_type="or",type = "full"}}
		local EductRecord = {}
		EductRecord.station="eduction "..item_name
		EductRecord.wait_conditions = {{compare_type="or",type = "empty"}}
		return {current = 1,records ={ProductRecord,EductRecord}}
end

function is_fuel_needed(train)
	for i,loco in pairs(combine_tables(train.locomotives.front_movers,train.locomotives.back_movers))do
		loco.get_fuel_inventory().sort_and_merge()
		--game.print(loco.get_fuel_inventory()[#loco.get_fuel_inventory()].valid_for_read)
		for i = 1, #loco.get_fuel_inventory() do
			if not loco.get_fuel_inventory()[i].valid_for_read then 
				return true
			end
		end
	end
	return false
end	

function add_train_stop_gui(event)
	if not game.players[event.player_index].gui.relative["qts_train_stop_gui"] then
		local anchor = {gui = defines.relative_gui_type.train_stop_gui, position = defines.relative_gui_position.right}
		local train_stop_gui = game.players[event.player_index].gui.relative.add({type="frame", name="qts_train_stop_gui", caption="Quick Train Stop", enabled=true,direction = "vertical",anchor =anchor})
		if qts_preselected and qts_preselected[event.player_index] and qts_preselected[event.player_index].signal_chooser then
			train_stop_gui.add({type="choose-elem-button", name="signal-chooser", caption="Quick Train Stop", enabled=true,elem_type ="signal",item=fts_preselected[event.player_index].signal_chooser})
        else
			train_stop_gui.add({type="choose-elem-button", name="signal-chooser", caption="Quick Train Stop", enabled=true,elem_type ="signal"})
		end 	
		train_stop_gui.add({type="button", name="empty-buttom", caption="simple name", enabled=true,mouse_button_filter ={"left"}})
		train_stop_gui.add({type="button", name="production-buttom", caption="production", enabled=true,mouse_button_filter ={"left"}})
		train_stop_gui.add({type="button", name="eduction-buttom", caption="eduction", enabled=true,mouse_button_filter ={"left"}})
		train_stop_gui.add({type="button", name="fuel-buttom", caption="fuel", enabled=true,mouse_button_filter ={"left"}})

        --needed to reference the train stop later
		local entity_preview = train_stop_gui.add({type="entity-preview",name="entity-preview", enabled=false})
	else
		if fts_preselected and fts_preselected[event.player_index] then
			game.players[event.player_index].gui.relative.qts_train_stop_gui["signal-chooser"].elem_value = fts_preselected[event.player_index].signal_chooser
		end
	end
	game.players[event.player_index].gui.relative.qts_train_stop_gui["entity-preview"].entity = event.entity
	
end


function add_train_gui(event)
	if not game.players[event.player_index].gui.relative["qts_train_gui"] then
		local anchor = {gui = defines.relative_gui_type.train_gui, position = defines.relative_gui_position.right}
		local train_gui = game.players[event.player_index].gui.relative.add({type="frame", name="qts_train_gui", caption="Quick Train Shedule", enabled=true,direction = "vertical",anchor =anchor})
		if fts_preselected and fts_preselected[event.player_index] and fts_preselected[event.player_index].signal_chooser then
			train_gui.add({type="choose-elem-button", name="signal-chooser", caption="Quick Train Stop", enabled=true,elem_type ="signal",item=fts_preselected[event.player_index].signal_chooser})
		else
			train_gui.add({type="choose-elem-button", name="signal-chooser", caption="Quick Train Stop", enabled=true,elem_type ="signal"})
		end 
		train_gui.add({type="button", name="confirmed-buttom", caption="Confirm", enabled=true,mouse_button_filter ={"left"}})
		local entity_preview = train_gui.add({type="entity-preview",name="entity-preview", enabled=false})
		entity_preview.entity = event.entity
	else
		if fts_preselected and fts_preselected[event.player_index] then
			game.players[event.player_index].gui.relative.qts_train_gui["signal-chooser"].elem_value = fts_preselected[event.player_index].signal_chooser
		end
	end
end



script.on_event(defines.events.on_gui_opened, function(event)
	if event.gui_type == defines.gui_type.entity and event.entity.name == "locomotive" then
		add_train_gui(event)
	end

	if event.gui_type == defines.gui_type.entity and event.entity.name == "train-stop" then
		add_train_stop_gui(event)
	end
end)

function reopen_vanilla_gui(player_index,tick)
	if not fts_to_open_list then fts_to_open_list = {} end
	local entry = {}
	entry.player_index = player_index
	entry.opened = game.players[player_index].opened
	entry.tick = tick
	table.insert(fts_to_open_list,entry)
	game.players[player_index].opened = nil
end

script.on_event(defines.events.on_gui_elem_changed, function(event)
	if event.element.name=="signal-chooser" then
		if not fts_preselected then fts_preselected = {} end
		if not fts_preselected[event.player_index] then fts_preselected[event.player_index] = {} end
		fts_preselected[event.player_index].signal_chooser = event.element.elem_value 

	end
end)


--script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
--	create_host_translation_dict()
--end)

function get_name_from_signal_id(signal_id)
	if signal_id == nil then
		return ""
	end
	if settings.global["qts_language_setting"].value == "qts_host" then
		return "not implemented"
	end
	if settings.global["qts_language_setting"].value == "qts_internal" then
		return signal_id.name
	end
	if settings.global["qts_language_setting"].value == "qts_player" then
		return signal_id.localised_name
	end
end


--script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
--	create_host_translation_dict()
--end)
--
--script.on_event(defines.events.on_load, function(event)
--	create_host_translation_dict()
--end)



--script.on_event(defines.events.on_string_translated, function(event)
--	print(event) 
--
--	--train_stop.backer_name = name
--	--reopen_vanilla_gui(event.player_index,event.tick)
--end)

script.on_event(defines.events.on_gui_click, function(event)
	local production = "x"
	local eduction = "x"
	local fuel = "x"
	local station = "x"
	if translations == nil then
		translations = {}
	end
	
	if settings.global["qts_language_setting"].value == "qts_host" then
		production = "not implemented"
		eduction = "not implemented"
		fuel = "not implemented"
		plain_station = "not implemented"
	end
	if settings.global["qts_language_setting"].value == "qts_internal" then
		production = "production"
		eduction = "eduction"
		fuel = "fuel"
		plain_station = "station"
	end
	if settings.global["qts_language_setting"].value == "qts_player" then
		production = "not implemented"
		eduction = "not implemented"
		fuel = "not implemented"
		plain_station = "not implemented"
	end

	if event.element.name == "empty-buttom" then
		local train_stop = event.element.parent["entity-preview"].entity
		local signal_id = event.element.parent["signal-chooser"].elem_value
		local name = get_name_from_signal_id(signal_id) 
		if name == "" then
			name = plain_station
		end
		train_stop.backer_name = name
		reopen_vanilla_gui(event.player_index,event.tick)
	end
 
	if event.element.name == "production-buttom" then

		local train_stop = event.element.parent["entity-preview"].entity
		local signal_id = event.element.parent["signal-chooser"].elem_value
		local name = production .. " " .. get_name_from_signal_id(signal_id)
		train_stop.backer_name = name
		reopen_vanilla_gui(event.player_index,event.tick)

	end
	if event.element.name == "eduction-buttom" then
		local train_stop = event.element.parent["entity-preview"].entity
		local signal_id = event.element.parent["signal-chooser"].elem_value
		local name =  eduction  .. " " .. get_name_from_signal_id(signal_id)
		train_stop.backer_name = name
		reopen_vanilla_gui(event.player_index,event.tick)

	end

	if event.element.name == "fuel-buttom" then
		game.players[event.player_index].print("not implemented yet")
		reopen_vanilla_gui(event.player_index,event.tick)
	end

	if event.element.name == "confirmed-buttom" then
		local train = event.element.parent["entity-preview"].entity.train
		local signal_id = event.element.parent["signal-chooser"].elem_value
		
		local name = get_name_from_signal_id(signal_id)
		train.schedule = create_new_shedule(train,name)
	end
end)

script.on_event(defines.events.on_tick, function(event)
	if event.tick%120 == 113 then
		for _,surface in pairs(game.surfaces)do
			for _,train in pairs(surface.get_trains())do
				if train.valid and not train.manual_mode and train.schedule and is_fuel_needed(train) and not has_train_temp_stop(train) then
					if get_table_length(game.get_train_stops({name = get_refulling_station_name(train)})) == 0 then
						ShowFlyingText(train, "no train station named: "..get_refulling_station_name(train), {255,0,0}, -2)
					else
						train.schedule =get_schedule_with_refueling(train)
					end
				end
			end
		end
	end

	if fts_to_open_list then
		for i,entry in pairs(fts_to_open_list) do
			if entry.tick+10 == event.tick then
				game.players[entry.player_index].opened = entry.opened
				table.remove(fts_to_open_list,i)
			end		
		end
	end
end)

--function close_windows(event)
--	local player = game.players[event.player_index]
--    if player.gui.left["qts_train_stop_gui"] then
--    	player.gui.left["qts_train_stop_gui"].destroy() 
--	end
--	if player.gui.left["qts_train_gui"] then
--    	player.gui.left["qts_train_gui"].destroy() 
--	end
--
--end

--script.on_event("fts-close-window", function(event)
--    close_windows(event)
--end)
--
--script.on_event("fts-close-window2", function(event)
--    close_windows(event)
--end)

--script.on_event(defines.events.on_gui_closed, function(event)
--	if event.gui_type == defines.gui_type.entity and event.entity.name == "locomotive" then
--    	local player = game.players[event.player_index]
--    	if player.gui.left["train_stop_gui"] then
--   		 	player.gui.left["train_stop_gui"].destroy() 
--		end
--		if player.gui.left["train_gui"] then
--    		player.gui.left["train_gui"].destroy() 
--		end
--	end
--end)

script.on_event(defines.events.on_entity_renamed, function(event)
	if not event.by_script then
        if game.players[event.player_index] then
            local player = game.players[event.player_index]
            if player.gui.left["qts_train_stop_gui"] then
                player.gui.left["qts_train_stop_gui"].destroy() 
            end
            if player.gui.left["qts_train_gui"] then
                player.gui.left["qts_train_gui"].destroy() 
            end
        end
	end
end)