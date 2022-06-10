script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    player.print{"message.omni-difficulty"}
end)

script.on_init(function(event)
    if remote.interfaces["freeplay"] then
        local items_to_insert = remote.call("freeplay", "get_created_items")
        items_to_insert["burner-omnitractor"] = (items_to_insert["burner-omnitractor"] or 0) + 1
        items_to_insert["burner-mining-drill"] = (items_to_insert["burner-mining-drill"] or 0) + 1
        if not game.active_mods["aai-industry"] and game.entity_prototypes["burner-omniphlog"] then
            items_to_insert["burner-omniphlog"] = (items_to_insert["burner-omniphlog"] or 0) + 1
        end
        remote.call("freeplay", "set_created_items", items_to_insert)
    end
end)