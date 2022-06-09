script.on_event(defines.events.on_player_created, function(event)
    local iteminsert = game.players[event.player_index].insert
    if #game.players == 1 then
        if game.active_mods["aai-industry"] then
            iteminsert{name="burner-assembling-machine", count=1}
        elseif game.active_mods["omnimatter_energy"] then
            iteminsert{name="omnitor-assembling-machine", count=1}
        else
            iteminsert{name="assembling-machine-1", count=1}
        end
        iteminsert{name="burner-omnicosm", count=1}
    end
end)