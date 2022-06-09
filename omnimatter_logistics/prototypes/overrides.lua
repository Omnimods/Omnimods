local nr_armour = settings.startup["omnilogistics-nr-armour"].value
local nr_bots = settings.startup["omnilogistics-nr-bots"].value

---------------------------------------------------------------
-- Armour updates
---------------------------------------------------------------
omni.lib.replace_recipe_ingredient("modular-armor", "heavy-armor","omni-armour-"..nr_armour)
omni.lib.add_unlock_recipe("omnibots-construction-1", "omni-roboport-equipment")
omni.lib.add_recipe_ingredient("personal-roboport-equipment",{type="item",name="omni-roboport-equipment",amount=1})
omni.lib.add_prerequisite("modular-armor","omni-armour-"..nr_armour)
omni.lib.remove_prerequisite("modular-armor","heavy-armor")
---------------------------------------------------------------
-- Construction bot updates
  -- omnimarathon updates, not sure if this section is even needed
---------------------------------------------------------------
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
    for j=2, nr_armour do
        omni.marathon.equalize("omni-armour-"..j-1,"omni-armour-"..j)
        omni.marathon.normalize("omni-armour-"..j)
    end
    for k=2, nr_bots do
        omni.marathon.equalize("omni-construction-robot-"..k-1,"omni-construction-robot-"..k)
        omni.marathon.equalize("omni-logistic-robot-"..k-1,"omni-logistic-robot-"..k)
    end
    omni.marathon.equalize("cargo-robot","cargo-robot-2")
end
---------------------------------------------------------------
-- Construction bot updates
---------------------------------------------------------------
if mods["angelsindustries"] then
  --construction bot system updates
    omni.lib.add_prerequisite("angels-construction-robots","omnibots-construction-"..nr_bots)
    
  omni.lib.add_prerequisite("construction-robotics","angels-construction-robots")
  omni.lib.add_recipe_ingredient("angels-construction-robot",{type="item",name="omni-construction-robot-"..nr_bots,amount=1})
  --omni.marathon.equalize("omni-construction-robot-"..nr_bots,"angels-construction-robot")
  --omni.lib.add_recipe_ingredient("construction-robot",{type="item",name="angels-construction-robot",amount=1})
  --omni.marathon.equalize("angels-construction-robot","construction-robot")

  --logistic bot system updates
  omni.lib.add_prerequisite("cargo-robots","omnibots-logistic-"..nr_bots)
    omni.lib.add_prerequisite("logistic-robotics","cargo-robots-2")
  
  --omni.lib.add_recipe_ingredient("cargo-robot-2",{type="item",name="cargo-robot",amount=1})
  --omni.marathon.equalize("cargo-robot","cargo-robot")
  omni.lib.add_recipe_ingredient("cargo-robot",{type="item",name="omni-logistic-robot-"..nr_bots,amount=1})
    --omni.marathon.equalize("omni-logistic-robot-"..nr_bots,"cargo-robot")
    --omni.lib.add_recipe_ingredient("logistic-robot",{type="item",name="cargo-robot-2",amount=1})
    --omni.marathon.equalize("cargo-robot-2","logistic-robot")
else
  omni.lib.add_prerequisite("construction-robotics","omnibots-construction-"..nr_bots)    
  
  omni.lib.add_prerequisite("logistic-robotics","omnibots-logistic-"..nr_bots)
    omni.lib.add_recipe_ingredient("logistic-robot",{type="item",name="omni-logistic-robot-"..nr_bots,amount=1})
    --omni.marathon.equalize("omni-logistic-robot-"..nr_bots,"logistic-robot")
end
---------------------------------------------------------------
-- Logistic Chest updates
  -- May want to add in the other chests? they exist already
---------------------------------------------------------------
omni.lib.remove_recipe_all_techs("angels-logistic-chest-requester")
omni.lib.remove_recipe_all_techs("angels-logistic-chest-passive-provider")
omni.lib.remove_recipe_all_techs("angels-big-chest")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-logistic-chest-requester")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-logistic-chest-passive-provider")
omni.lib.add_unlock_recipe("omnibots-logistic-1","angels-big-chest")

if mods["aai-industry"] then
    omni.lib.replace_recipe_ingredient("omni-shoes-1","copper-cable",{"electric-motor",5})
end
---------------------------------------------------------------
-- Infrastructure updates updates
---------------------------------------------------------------
local robounlock=1
if nr_bots>=2 then
  robounlock=nr_bots-1
end
omni.lib.add_unlock_recipe("omnibots-construction-1","omni-construction-roboport")
omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-logistic-roboport")
omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-zone-expander")
omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-relay-station")
omni.lib.add_unlock_recipe("omnibots-logistic-"..robounlock,"omni-roboport")
--omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-zone-expander-2")
--omni.lib.add_unlock_recipe("omnibots-logistic-1","omni-relay-station-2")

