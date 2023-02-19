

f
--localisation stuff


--
--function getTranslation(localised_name, player_id)
--
--end
--
script.on_event(defines.events.on_string_translated, function(event)
	
end)



function setPlayerTranslations(player)
    local requests = {}
    
	--player.request_translations({qts_production,qts_eduction,qts_fuel,qts_station})
    for name,signal in pairs(game.virtual_signal_prototypes) do print
        table.insert(requests,signal.localised_name) 
    end
    player.request_translations(requests)
end


function translator_init()
    print("test") 
    localisation_table = localisation_table or {}
    for player in game.players do
        getPlayerTranslations(player)
    end
end



script.on_event(defines.events.on_player_joined_game, function(event)
    translator_init()
    --setPlayerTranslations(game.get_player(event.player_index))
end) 

script.on_event(defines.events.on_init, function(event)
    translator_init()
    --setPlayerTranslations(game.get_player(event.player_index))
end) 


script.on_load(function(event)
    translator_init()
end)