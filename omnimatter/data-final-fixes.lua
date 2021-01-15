-----------------
-----COMPATS-----
-----------------
require("prototypes.compat.bob-burnerphase")

-----------------------
-----Late requires-----
-----------------------
require("prototypes.recipes.omnic-water")
require("prototypes.generation.autoplace-removal")


--Add last extraction techs as rocket silo prereq
if omni.rocket_locked then
	--Get highest ore and fluid tier
	local max_tier = 0
	local max_fluid_tier = 0
	for k,v in pairs(omni.matter.omnisource) do
		max_tier = k
	end
	for k,v in pairs(omni.matter.omnifluid) do
		max_fluid_tier = k
	end

	--Check if there is a higher fluid than ore tier
	if max_tier > max_fluid_tier then
		local pure_extractions = 3 * omni.pure_levels_per_tier
		for _,ore in pairs(omni.matter.omnisource[tostring(max_tier)]) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-extraction-"..ore.name.."-"..pure_extractions)
		end
	end
	--Check if there is a higher ore than fluid tier
	if max_fluid_tier > max_tier then
		for _,fluid in pairs(omni.matter.omnifluid[tostring(max_fluid_tier)]) do
			omni.lib.add_prerequisite("rocket-silo","omnitech-distillation-"..fluid.name.."-"..omni.fluid_levels)
		end
	end
end

for _,f in pairs(data.raw.fluid) do
	data.raw.recipe["angels-fluid-splitter-"..f.name]=nil
end

RecGen:import("coal-liquefaction"):
	replaceIngredients("heavy-oil","omniston"):
	replaceIngredients("liquid-naphtha","omniston"):
	extend()