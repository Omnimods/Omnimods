for _, force in pairs(game.forces) do
  force.reset_recipes()
  force.reset_technologies()
end


for i, force in pairs(game.forces) do 
	for i=1,4 do
		if force.technologies["crystallonics-"..i].researched then
			for _, eff in pairs(force.technologies["crystallonics-"..i].effects) do
				if eff.type=="unlock-recipe" then
					force.recipes[eff.recipe].enabled=true
				end
			end
		end
		if force.technologies["crystallology-"..i].researched then
			for _, eff in pairs(force.technologies["crystallonics-"..i].effects) do
				if eff.type=="unlock-recipe" then
					force.recipes[eff.recipe].enabled=true
				end
			end
		end
	end
	force.recipes["science-pack-3"].reload()
	force.recipes["high-tech-science-pack"].ingredients[1].name="copper-lead-tin-circuit-1"
end

