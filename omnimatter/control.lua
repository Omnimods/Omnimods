script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    if player.controller_type ~= defines.controllers.god then
        player.insert{name = "burner-omnitractor", count = 1}
		local noAAII = true
		for name, version in pairs(game.active_mods) do
			if name=="aai-industry" then
				noAAII = false
				break
			end
		end
		if not noAAII and game.entity_prototypes["burner-omniphlog"] then
			player.insert{name = "burner-omniphlog", count = 1}
		end
    end
    player.print{"message.omni-difficulty"}
end)