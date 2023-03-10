-------------------------------------------------------------------------------
--Mod by HanniWalter
-------------------------------------------------------------------------------

require "util"
require "refill"
require "gui"
--require "translator"

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

function create_new_shedule(train,item_name,production,eduction) 
	if item_name == "" then
		local ProductRecord = {}
		ProductRecord.station=production
		ProductRecord.wait_conditions = {{compare_type="or",type = "full"}}
		local EductRecord = {}
		EductRecord.station=eduction
		EductRecord.wait_conditions = {{compare_type="or",type = "empty"}}
		return {current = 1,records ={ProductRecord,EductRecord}}
	end
		local ProductRecord = {}
		ProductRecord.station=production .. " "..item_name
		ProductRecord.wait_conditions = {{compare_type="or",type = "full"}}
		local EductRecord = {}
		EductRecord.station=eduction .." "..item_name
		EductRecord.wait_conditions = {{compare_type="or",type = "empty"}}
		return {current = 1,records ={ProductRecord,EductRecord}}
end

script.on_event(defines.events.on_tick, function(event)
	-- refuelling check
	refuelling_tick(event)

	if fts_to_open_list then
		for i,entry in pairs(fts_to_open_list) do
			if entry.tick+10 == event.tick then
				game.players[entry.player_index].opened = entry.opened
				table.remove(fts_to_open_list,i)
			end		
		end
	end
end)