omni.lib.add_unlock_recipe("omnitractor-electric-1","omnissenced-wood")
omni.lib.add_unlock_recipe("crystallology-1","omnissenced-iron-crystal")


--omnicium-plate
RecGen:importIf("omnite-smelting"):replaceIngredients("copper-ore",{"copper-iron-ore-mix",24}):removeIngredients("iron-ore"):extend()

RecGen:importIf("omnicium-processing"):replaceIngredients("copper-ore",{"copper-iron-ore-mix",4}):removeIngredients("iron-ore"):extend()

omni.lib.add_unlock_recipe("omnipack-technology","ingot-mingnisium")
omni.lib.add_unlock_recipe("omnitractor-electric-3","crushed-mixture")
omni.lib.add_unlock_recipe("omnitractor-electric-3","hydrosalamite")
omni.lib.add_unlock_recipe("omnitractor-electric-3","omnissenced-plastic")

if mods["omnimatter_marathon"] then
	omni.marathon.exclude_recipe("ore-mix-essence")
	omni.marathon.exclude_recipe("copper-iron-ore-mix")
end

RecGen:import("automation-science-pack"):setNormalIngredients({name="liquid-molten-omnicium",amount=100,type="fluid"},{"ore-mix-essence",2}):
	setExpensiveIngredients({name="liquid-molten-omnicium",amount=200,type="fluid"},{"ore-mix-essence",3}):
	marathon():extend()

RecGen:import("logistic-science-pack"):setIngredients({"orthomnide",3},"omnidized-steel",{"omnissenced-wood",2}):
	setResults({"logistic-science-pack",3}):setEnabled(false):extend()
	
RecGen:import("chemical-science-pack"):setIngredients({"chlorodizing-omnikaryote",10},{"hydrosalamite",1},{"carbomnilline",2},{"omnissenced-plastic",1}):extend()

RecGen:import("omni-pack"):setIngredients({"omnissenced-iron-crystal",3},{type="fluid",name="omniaescene",amount=75},{"ingot-mingnisium",2}):extend()

RecGen:importIf("ingot-iron-smelting"):setTechName("angels-iron-smelting-1"):extend()

local packs = {}
for _, lab in pairs(data.raw["lab"]) do
	for _, input in pairs(lab.inputs) do
		local rec = omni.lib.find_recipe(input)
		if rec then 
			data.raw.recipe[rec.name].category="research-facility"
			if rec.normal then
				data.raw.recipe[rec.name].normal.category="research-facility"
				data.raw.recipe[rec.name].expensive.category="research-facility"
			end
			packs[#packs+1]=data.raw.recipe[rec.name]
		end
	end
end