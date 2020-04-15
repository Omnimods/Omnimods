--mapping of unlocks for omnienergy vs bobs vs burner phase
--For the benefit of cleaning up the tech tree and assisting people in "going down the right path"
--General rule of thumb... burner-->steam-->heat based power-->steam based power
--First step (clobber bobs burner lab)
--second step, remove steam engine from steam power tech (leave offshore pump and boiler)
--add anbaricity as a pre-req to steam power and electricity
--remove anbaric lab tech
--remove mining drill and small-electric pole and inserter from electricity
--tempted to move steam-engine behind green in the interim (but can balance that back out)
--consider shifting everything pre-"lab" to steam science packs, then pre-req of red science to be steam power (not engine)

-- Remove bobs burner lab
table.insert(data.raw["lab"]["omnitor-lab"].inputs, "steam-science-pack")
data.raw.recipe["burner-lab"].enabled=false
omni.lib.remove_recipe_ingredient("lab", "burner-lab")
-- Remove steam engine from steam power technology
omni.lib.remove_unlock_recipe("steam-power","steam-engine")
-- Add anbarcity to pre-requisites
omni.lib.add_prerequisite("steam-power", "anbaricity")
omni.lib.add_prerequisite("electricity", "anbaricity")
data.raw.technology["anbaric-lab"].hidden=true --i hope this works
-- Remove duplicate recipe unlocks
omni.lib.remove_unlock_recipe("electricity","small-electric-pole")
omni.lib.remove_unlock_recipe("electricity","electric-mining-drill")
omni.lib.remove_unlock_recipe("electricity","inserter")
-- Move steam-engine waaay back
omni.lib.add_prerequisite("bob-steam-engine-1", "automation-science-pack")
omni.lib.add_prerequisite("automation-science-pack", "electricity")
omni.lib.add_prerequisite("automation-science-pack", "steam-power")
--change technologies to be steam pack in place of red packs
--omni.lib.replace_science_pack(tech,old, new)
omni.lib.replace_science_pack("base-impure-extraction","automation-science-pack", "steam-science-pack")
omni.lib.replace_science_pack("anbaricity","automation-science-pack", "steam-science-pack")
omni.lib.replace_science_pack("simple-automation","automation-science-pack", "steam-science-pack")
if mods["boblogistics"] and settings.startup["bobmods-logistics-beltoverhaul"].value then
    omni.lib.replace_science_pack("basic-belt-logistics","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("basic-underground-logistics","automation-science-pack", "steam-science-pack")
    omni.lib.replace_science_pack("basic-splitter-logistics","automation-science-pack", "steam-science-pack")
end
omni.lib.replace_science_pack("bob-steam-engine-1", "steam-science-pack","automation-science-pack")
omni.lib.replace_science_pack("bob-steam-engine-2", "steam-science-pack","automation-science-pack")