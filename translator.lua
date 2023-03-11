

--localisation stuff


--
--function getTranslation(localised_name, player_id)
--
--end
--
script.on_event(defines.events.on_string_translated, function(event)
	localisation_dict = localisation_dict or {}
    localisation_dict[event.player_index] = localisation_dict[event.player_index] or {}
    --localisation_dict[event.player_index][#localisation_dict[event.player_index]+1] = {event.localised_string,event.result }
    localisation_dict[event.player_index][event.localised_string[1]] = event.result
    print_table_to_file(localisation_dict,OUTPUT_FILE)
end)

function get_translation(player_index, localised_string)
    if not localisation_dict then 
        return nil
    end
    if not localisation_dict[player_index] then 
        return nil
    end
    if not localisation_dict[player_index] [localised_string[1]] then 
        return nil
    end
    return localisation_dict[player_index] [localised_string[1]] 
end

function request_player_translations(player)
    local requests = {}
    
	--player.request_translations({qts_production,qts_eduction,qts_fuel,qts_station})
    for name,signal in pairs(game.virtual_signal_prototypes) do 
        table.insert(requests,signal.localised_name) 
    end
    for name,item in pairs(game.item_prototypes ) do 
        table.insert(requests,item.localised_name) 
    end
    for name,fluid in pairs(game.fluid_prototypes  ) do 
        table.insert(requests,fluid.localised_name) 
    end
    table.insert(requests,{"qts.qts_production"}) 
    table.insert(requests,{"qts.qts_eduction"}) 
    table.insert(requests,{"qts.qts_fuel"}) 
    table.insert(requests,{"qts.qts_station"}) 

    player.request_translations(requests)
end

function translator_init() 
    for i,player in pairs(game.players) do
        request_player_translations(player) 
    end
end

function translator_player_joined(event)
    request_player_translations(game.get_player(event.player_id))
end

--translator_init()
