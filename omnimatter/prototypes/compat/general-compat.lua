--Disable pumpjack techs and recipes
for i,tech in pairs(data.raw.technology) do
	if string.find(tech.name, "pumpjack") then
		--table.remove(data.raw.technology,i)
		data.raw.technology[tech.name].enabled=false
	elseif tech.prerequisites and next(tech.prerequisites) then
		for j=1,#tech.prerequisites do
			if tech.prerequisites[j] and string.find(tech.prerequisites[j],"pumpjack") then
				data.raw.technology[tech.name].prerequisites[j]=nil
			end
		end
		if tech and tech.effects then
			for i,eff in pairs(tech.effects) do
				if eff.type == "unlock-recipe" and string.find(eff.recipe,"pumpjack") then
					table.remove(data.raw.technology[tech.name].effects,i)
				end
			end
		end
	end
end

for _,rec in pairs(data.raw.recipe) do
	if omni.lib.recipe_result_contains_string(rec.name, "pumpjack") then
		omni.lib.disable_recipe(rec.name)
	end
end