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