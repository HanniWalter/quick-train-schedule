-------------------------------------------------------------------------------
--Mod by HanniWalter
-------------------------------------------------------------------------------

require "util"
require "refill"
require "gui"
require "translator"

function create_new_shedule(train,production_station_name,eduction_station_name) 
	local ProductRecord = {}
	ProductRecord.station=production_station_name
	ProductRecord.wait_conditions = {{compare_type="or",type = "full"}}
	local EductRecord = {}
	EductRecord.station=eduction_station_name
	EductRecord.wait_conditions = {{compare_type="or",type = "empty"}}
	return {current = 1,records ={ProductRecord,EductRecord}}
end

init = false

script.on_load(function(event)
    init = true
end)

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
	if init then
		init = false
		translator_init()
	end
end)
