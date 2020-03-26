omni.add_omniwaste()
require("prototypes.category")
require("prototypes.standard")
require("prototypes.angels-bioprocessing")
require("prototypes.bioindustries")

if mods["angelsbioprocessing"] then
	--omni.lib.add_prerequisite("bio-processing-green","omnialgae")
	omni.lib.add_prerequisite("bio-processing-brown","omnialgae")
	
	omni.lib.remove_unlock_recipe("bio-processing-green","algae-farm")
	
	omni.lib.add_recipe_ingredient("algae-green",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-brown",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-red",{type="item",name="omnialgae",amount=40})
	omni.lib.add_recipe_ingredient("algae-blue",{type="item",name="omnialgae",amount=40})
	
	for i=1,3 do
		local rec = data.raw.recipe["wood-sawing-"..i]
		omni.marathon.standardise(rec)
		for _,dif in pairs({"normal","expensive"}) do
			rec[dif].results[1].name="omniwood"
	--		rec[dif].results[1].amount=rec[dif].results[1].amount*4
		end
	--	omni.lib.replace_recipe_ingredient("tree-arboretum-"..i,"water","omnic-water")
		rec.icons[1].icon = data.raw.item["omniwood"].icons[1].icon
		rec.icon_size = 32
		rec.localised_name = {"item-name.omniwood"}
	end
end