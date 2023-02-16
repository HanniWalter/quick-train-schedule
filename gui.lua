
function add_train_stop_gui(event)
    if not global.fts_trainsize then 
        global.fts_trainsize = {}
    end
    if not global.fts_trainsize[event.player_index] then 
        global.fts_trainsize[event.player_index] = {1,3,1}
    end


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
		train_stop_gui.add({type="line", caption="eduction", enabled=true})

	    local table = train_stop_gui.add{type = "table", name = "table", column_count = 3}
        table.add{type = "label", name = "title1", caption = "front locomotives "}
	    table.add{type = "slider", name = "qts_slider1", style="notched_slider", minimum_value=0, maximum_value=9, value=global.fts_trainsize[event.player_index][1], value_step=1, discrete_slider=true}
	    table.add{type = "textfield", name = "qts_slider_text1", text=global.fts_trainsize[event.player_index][1],style="slider_value_textfield", numeric=true, allow_decimal=false, allow_negative=false, lose_focus_on_confirm=true}

	    table.add{type = "label", name = "title2", caption = "wagon count "}
	    table.add{type = "slider", name = "qts_slider2", style="notched_slider", minimum_value=0, maximum_value=9, value=global.fts_trainsize[event.player_index][2], value_step=1, discrete_slider=true}
	    table.add{type = "textfield", name = "qts_slider_text2", text=global.fts_trainsize[event.player_index][2],style="slider_value_textfield", numeric=true, allow_decimal=false, allow_negative=false, lose_focus_on_confirm=true}

	    table.add{type = "label", name = "title3", caption = "back locomotives "}
	    table.add{type = "slider", name = "qts_slider3", style="notched_slider", minimum_value=0, maximum_value=9, value=global.fts_trainsize[event.player_index][3], value_step=1, discrete_slider=true}
	    table.add{type = "textfield", name = "qts_slider_text3", text=global.fts_trainsize[event.player_index][3],style="slider_value_textfield", numeric=true, allow_decimal=false, allow_negative=false, lose_focus_on_confirm=true}

		train_stop_gui.add({type="button", name="fuel-buttom", caption="fuel", enabled=true,mouse_button_filter ={"left"}})

        --needed to reference the train stop later
		local entity_preview = train_stop_gui.add({type="entity-preview",name="entity-preview", enabled=false})
	else
		if fts_preselected and fts_preselected[event.player_index] then
			game.players[event.player_index].gui.relative.qts_train_stop_gui["signal-chooser"].elem_value = fts_preselected[event.player_index].signal_chooser
		end
	end
	game.players[event.player_index].gui.relative.qts_train_stop_gui["entity-preview"].entity = event.entity
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text1"].text = tostring(global.fts_trainsize[event.player_index][1])
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text2"].text = tostring(global.fts_trainsize[event.player_index][2])
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text3"].text = tostring(global.fts_trainsize[event.player_index][3])
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider1"].slider_value  = global.fts_trainsize[event.player_index][1]
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider2"].slider_value  = global.fts_trainsize[event.player_index][2]
	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider3"].slider_value  = global.fts_trainsize[event.player_index][3]
end

function get_refuelstation_string(player_index) 
    if not global.fts_trainsize then 
        global.fts_trainsize = {}
    end
    if not global.fts_trainsize[player_index] then 
        global.fts_trainsize[player_index] = {1,3,1}
    end
    ret = ""
    for i=1,global.fts_trainsize[player_index][1] do ret = ret.."L" end
    for i=1,global.fts_trainsize[player_index][2] do ret = ret.."C" end
    for i=1,global.fts_trainsize[player_index][3] do ret = ret.."L" end
    return ret
    
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

script.on_event(defines.events.on_gui_value_changed, function(event)
    if not global.fts_trainsize then 
        global.fts_trainsize = {}
    end
    if not global.fts_trainsize[event.player_index] then 
        global.fts_trainsize[event.player_index] = {1,3,1}
    end
	if event.element and event.element.name == "qts_slider1" then
        global.fts_trainsize[event.player_index][1] = event.element.slider_value 
        game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text1"].text = tostring(global.fts_trainsize[event.player_index][1])
    end
    if event.element and event.element.name == "qts_slider2" then
        global.fts_trainsize[event.player_index][2] = event.element.slider_value 
    	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text2"].text = tostring(global.fts_trainsize[event.player_index][2])
    end
    if event.element and event.element.name == "qts_slider3" then
        global.fts_trainsize[event.player_index][3] = event.element.slider_value 
    	game.players[event.player_index].gui.relative.qts_train_stop_gui.table["qts_slider_text3"].text = tostring(global.fts_trainsize[event.player_index][3])
    end
end) 

script.on_event(defines.events.on_gui_text_changed, function(event)
	if event.element and event.element.name == "qts_slider_text1" then
        if type(tonumber(event.element.text)) == "number" then 
            global.fts_trainsize[event.player_index][1] = event.element.text  
            event.element.parent["qts_slider1"].slider_value = global.fts_trainsize[event.player_index][1]
        end
    end
    if event.element and event.element.name == "qts_slider_text2" then
        if type(tonumber(event.element.text)) == "number" then 
         global.fts_trainsize[event.player_index][2] = event.element.text 
          event.element.parent["qts_slider2"].slider_value = global.fts_trainsize[event.player_index][2]
        end
    end
    if event.element and event.element.name == "qts_slider_text3" then
        if type(tonumber(event.element.text)) == "number" then 
            global.fts_trainsize[event.player_index][3] = event.element.text 
            event.element.parent["qts_slider3"].slider_value = global.fts_trainsize[event.player_index][3]
        end
    end
end) 


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
        local item_name = get_name_from_signal_id(signal_id)
        local name =  production 
        if not item_name == "" then 
            name =  production  .. " " .. get_name_from_signal_id(signal_id)
		end
		train_stop.backer_name = name
		reopen_vanilla_gui(event.player_index,event.tick)

	end
	if event.element.name == "eduction-buttom" then
		local train_stop = event.element.parent["entity-preview"].entity
		local signal_id = event.element.parent["signal-chooser"].elem_value
        local item_name = get_name_from_signal_id(signal_id)
        local name = eduction 
        if not item_name == "" then 
            local name =  eduction  .. " " .. get_name_from_signal_id(signal_id)
		end
        train_stop.backer_name = name
		reopen_vanilla_gui(event.player_index,event.tick)

	end

	if event.element.name == "fuel-buttom" then
        local train_stop = event.element.parent["entity-preview"].entity
        train_stop.backer_name = fuel .. " " .. get_refuelstation_string(event.player_index)
		reopen_vanilla_gui(event.player_index,event.tick)
	end

	if event.element.name == "confirmed-buttom" then
		local train = event.element.parent["entity-preview"].entity.train
		local signal_id = event.element.parent["signal-chooser"].elem_value
		
		local name = get_name_from_signal_id(signal_id)
		train.schedule = create_new_shedule(train,name)
	end
end)