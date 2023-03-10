require "util"

function get_schedule_with_refueling(train,stopname)
	local current = train.schedule.current
	local FuelTrainScheduleRecord = {}
	FuelTrainScheduleRecord.station=stopname
	FuelTrainScheduleRecord.wait_conditions = {{compare_type="or",type = "inactivity",ticks = 60}}
	FuelTrainScheduleRecord.temporary = true
	local records = train.schedule.records
	if settings.global["qts_insert"].value == "qts_now" then
        table.insert(records,current,FuelTrainScheduleRecord)
    end
	if settings.global["qts_insert"].value == "qts_next" then
        table.insert(records,current+1,FuelTrainScheduleRecord)
    end
	if settings.global["qts_insert"].value == "qts_last" then
        table.insert(records,FuelTrainScheduleRecord)
    end
	local returner = {}
	returner.current = current
	returner.records = records
	return returner
end

-- in MJ
function get_fuel_value(item)
    return game.item_prototypes[item].fuel_value/1000000
end

function is_fuel_needed(train)
	for i,loco in pairs(combine_tables(train.locomotives.front_movers,train.locomotives.back_movers))do
		loco.get_fuel_inventory().sort_and_merge()
		local fuelValue = 0
		--game.print(loco.get_fuel_inventory()[#loco.get_fuel_inventory()].valid_for_read)
		for i = 1, #loco.get_fuel_inventory() do
			local items = loco.get_fuel_inventory()[i]
			if items.valid_for_read then 
				local value = get_fuel_value(items.name)
                local count = items.count
                fuelValue = fuelValue + value * count
				--return true
			end
		end
		if fuelValue <= settings.global["qts_fuel_threshold"].value then
            return true
        end
	end
	return false
end	

function get_refill_string(train)
    local full = ""
	local carriages = train.carriages
	for _,car in pairs(carriages) do 
		if car.type == "locomotive" then
			full = full.."L"
		else
			full = full.."C"
		end
	end
	return full
end

function get_refill_string_short(train)
	local full = ""
    local shortend = full
	local carriages = train.carriages
	for _,car in pairs(carriages) do 
		if car.type == "locomotive" then
			full = full.."L"
            shortend = full
		else
			full = full.."C"
		end
	end
	return shortend
end

function get_refuel_station_name_train(train)
	--get_refuelstation_string(event.player_index)
    if settings.global["qts_language_setting"].value == "qts_internal" then
		return "refuel".. " " .. get_refill_string(train)
	end
	if settings.global["qts_language_setting"].value == "qts_host" then
		return get_translation(1, {"qts.qts_fuel"}) .. " " .. get_refill_string(train)
	end	
	if settings.global["qts_language_setting"].value == "qts_player" then
		return "not implemented"
	end
end

function does_name_fits(station_name, trainname, shortend)
	return station_name == trainname
end

function get_fitting_station_name(surface,train)
    local station_name = get_refuel_station_name_train(train)
	local stations = surface.get_train_stops{}

	for _,station in pairs(stations) do 
		if does_name_fits(station.backer_name, get_refuel_station_name_train(train), get_refuel_station_name_train(train)) then
			return station.backer_name
		end
	end
	return nil
end

function refuelling_tick(event)
    if settings.global["qts_enable_refueling_setting"].value == false then
        return
    end

    if not (event.tick%settings.global["qts_refuel_refresh_time_setting"].value  == settings.global["qts_refuel_refresh_time_offset_setting"].value) then
        return
    end
	for _,surface in pairs(game.surfaces)do
		for _,train in pairs(surface.get_trains())do
            if train.valid and not train.manual_mode and train.schedule and is_fuel_needed(train) and not has_train_temp_stop(train) then
                
				local stopname = get_fitting_station_name(surface,train)
			    if stopname then
                    train.schedule =get_schedule_with_refueling(train,stopname)
                else
                    if settings.global["qts_show_not_found_setting"].value == true then
                        show_flying_text(train, "no refulling station for this train found ", {255,0,0}, -2)
                    end    
                end
            end
		end
	end
end