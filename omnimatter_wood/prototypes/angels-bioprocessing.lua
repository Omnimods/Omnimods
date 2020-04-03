if mods["angelsbioprocessing"] then
	RecGen:create("omnimatter_wood","omnialgae"):
	setStacksize(500):
	setSubgroup("algae"):
	setTechName():
	setTechPrereq("omnimutator"):
	setTechIcon("angelsbioprocessing","algae-farm-tech"):
	setTechCost(250):
	setTechTime(15):
	setCategory("bio-processing"):
	setSubgroup("bio-processing-purple"):
	setIngredients({
	{type="fluid",name="omnic-acid",amount=144},
	{type="item",name="omnite",amount=24},
	}):
	setResults({type="item",name="omnialgae", amount = 144}):extend()
	omni.lib.add_unlock_recipe("omnialgae","algae-farm")
data:extend({{
    type = "item-subgroup",
    name = "bio-processing-purple",
	group = "bio-processing-nauvis",
	order = "a",
  }})
  data.raw.recipe["algae-green"].icons = nil
  data.raw.recipe["algae-green"].icon = data.raw.recipe["algae-green-simple"].icon
  data.raw.recipe["algae-green-simple"].hidden = true
end

RecGen:importIf("solid-soil"):setCategory("omnimutator"):addIngredients({type="fluid",name="omnic-acid",amount=20}):setTechName("omnimutator"):extend()