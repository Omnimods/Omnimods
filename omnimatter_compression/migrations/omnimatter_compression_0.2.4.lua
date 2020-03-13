for _, force in pairs(game.forces) do
  force.reset_recipes()
  force.reset_technologies()
end

function end_with(a,b)
	return string.sub(a,string.len(a)-string.len(b)+1) == b
end

for i, force in pairs(game.forces) do 
	if force.recipes["auto-compressor"].enabled then force.technologies["compression-initial"].researched = true end
	if force.technologies["compression-recipes"].researched then
		for _,tech in pairs(force.technologies) do
			if tech.researched then
				for _, eff in pairs(tech.effects) do
					if eff.type=="unlock-recipe" and eff.recipe and force.recipes[eff.recipe.."-compression"] then
						force.recipes[eff.recipe.."-compression"].enabled=true
					end
				end
			end
		end
	end
end

