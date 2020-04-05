require("prototypes/equipment/armour")
require("prototypes/equipment/generator")
require("prototypes/equipment/shoes")
require("prototypes/equipment/roboports")
require("prototypes/equipment/equipment-categories")

require("prototypes/recipes/armour")
require("prototypes/recipes/generator")
require("prototypes/recipes/shoes")
--require("prototypes/recipes/logistics-robots")

--require("prototypes/entities/omni-logistic-roboport")
require("prototypes/entities/construction-robot")
require("prototypes/entities/logistic-robot")
require("prototypes/entities/roboport")

require("equipment-grid")

require("prototypes/technology/omniquipment")

local i = 1
while data.raw.recipe["omni-armour-"..i] do
	i=i+1
end

omni.lib.replace_recipe_ingredient("modular-armor", "heavy-armor","omni-armour-"..i-1)
local nr_armour = settings.startup["omnilogistics-nr-armour"].value
local nr_bots = settings.startup["omnilogistics-nr-bots"].value

omni.lib.add_unlock_recipe("omnibots-construction-1", "omni-roboport-equipment")
omni.lib.add_recipe_ingredient("personal-roboport-equipment",{type="item",name="omni-roboport-equipment",amount=1})

if mods["omnimatter_marathon"] then
	omni.marathon.equalize("heavy-armor","primitive-armour")
	omni.marathon.equalize("primitive-armour","omni-armour-1")
	omni.marathon.equalize("omni-armour-"..nr_armour,"modular-armor")
	omni.marathon.normalize("primitive-armour")
	
	omni.marathon.normalize("omni-armour-"..1)
	omni.marathon.normalize("modular-armor")
	
	local power = {"modular-armor","power-armor","power-armor-mk2","bob-power-armor-mk3","bob-power-armor-mk4","bob-power-armor-mk5"}
	
	for i=1,#power do
		omni.marathon.normalize(power[i])
		if i>1 then
			omni.marathon.equalize(power[i-1],power[i])
		end
	end
	
	for i=2, nr_armour do
		omni.marathon.equalize("omni-armour-"..i-1,"omni-armour-"..i)
		omni.marathon.normalize("omni-armour-"..i)
	end
	for i=2, nr_bots do
		omni.marathon.equalize("omni-construction-robot-"..i-1,"omni-construction-robot-"..i)
		omni.marathon.equalize("omni-logistic-robot-"..i-1,"omni-logistic-robot-"..i)
	end
	
	omni.marathon.equalize("cargo-robot","cargo-robot-2")
end

local constr=0
while data.raw.technology["omnibots-construction-"..constr+1] do
	constr=constr+1
end
local logi=0
while data.raw.technology["omnibots-logistic-"..logi+1] do
	logi=logi+1
end
if mods["angelslogistics"] then
	omni.lib.add_prerequisite("angels-construction-robots","omnibots-construction-"..constr)
	omni.lib.add_prerequisite("cargo-robots","omnibots-logistic-"..logi)
	omni.lib.add_prerequisite("construction-robotics","angels-construction-robots")
	omni.lib.add_prerequisite("logistic-robotics","cargo-robots-2")
	omni.lib.add_recipe_ingredient("cargo-robot-2",{type="item",name="cargo-robot",amount=1})
	omni.marathon.equalize("cargo-robot","cargo-robot")
	omni.lib.add_recipe_ingredient("cargo-robot",{type="item",name="omni-logistic-robot-"..logi,amount=1})
	omni.marathon.equalize("omni-logistic-robot-"..logi,"cargo-robot")
	
	omni.lib.add_recipe_ingredient("logistic-robot",{type="item",name="cargo-robot",amount=1})
	omni.marathon.equalize("cargo-robot","logistic-robot")
	
	omni.lib.add_recipe_ingredient("angels-construction-robot",{type="item",name="omni-construction-robot-"..constr,amount=1})
	omni.marathon.equalize("omni-construction-robot-"..constr,"angels-construction-robot")

	omni.lib.add_recipe_ingredient("construction-robot",{type="item",name="angels-construction-robot",amount=1})
	omni.marathon.equalize("angels-construction-robot","construction-robot")
	
else
	omni.lib.add_prerequisite("logistic-robotics","omnibots-logistic-"..logi)
	omni.lib.add_prerequisite("construction-robotics","omnibots-construction-"..constr)	
	
	omni.lib.add_recipe_ingredient("logistic-robot",{type="item",name="omni-logistic-robot-"..logi,amount=1})
	omni.marathon.equalize("omni-logistic-robot-"..logi,"logistic-robot")
end

if mods["aai-industry"] then
	omni.lib.replace_recipe_ingredient("omni-shoes-1","copper-cable",{"electric-motor",5})
end

omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-roboport")
omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-zone-expander")
omni.lib.remove_recipe_all_techs("angels-logistic-chest-requester")
omni.lib.remove_recipe_all_techs("angels-logistic-chest-passive-provider")
omni.lib.remove_recipe_all_techs("angels-big-chest")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-logistic-chest-requester")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-logistic-chest-passive-provider")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-big-chest")

omni.lib.add_prerequisite("modular-armor","omni-armour-"..nr_armour)
omni.lib.remove_prerequisite("modular-armor","heavy-armor")