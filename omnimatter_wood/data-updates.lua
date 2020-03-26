
if mods["aai-industry-sp0"] then
	industry.add_tech("omniwaste")
end

if mods["omnimatter_marathon"] then
	omni.marathon.equalize("burner-omniphlog","omni-mutator")
end

--update ingredients
if mods["bobplates"] then	omni.lib.replace_recipe_ingredient("omnimutator","copper-plate","glass") end
