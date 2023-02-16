-------------------------------------------------------------------------------
--Mod by HanniWalter
-------------------------------------------------------------------------------

require "util"
require "refill"
require "gui"




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

script.on_event(defines.events.on_entity_renamed, function(event)
	if not event.by_script then
		if event.player_index then
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
	end
end)