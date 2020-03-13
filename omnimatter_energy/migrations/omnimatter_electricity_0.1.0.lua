for index, force in pairs(game.forces) do
  local technologies = force.technologies
  local recipes = force.recipes

	for i=1,4 do
		if technologies["crystallology-"..i].researched then
			for _, eff in pairs(technologies["crystallology-"..i].effects) do
				if eff.type=="unlock-recipe" then
					recipes[eff.recipe].enabled=true
				end
			end
		end
	end
end