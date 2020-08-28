-----------------------------------------------------------------------------
-- This is a file to allow the py mod sets to work with omnienergy ----------
-----------------------------------------------------------------------------
--tech fixes
if mods["pyalienlife"] then
  omni.lib.replace_prerequisite("fluid-handling","automation-2", "anbaricity")
end
--other tweaks
if mods["pycoalprocessing"] then
  local replacements = {}
  --entity updates
  local burners = {"distilator","fawogae-plantation-mk01","soil-extractormk01"}
  if mods["pyalienlife"] then
    local add_burn = {"research-center-mk01","micro-mine-mk01","moss-farm-mk01","sap-extractor-mk01","seaweed-crop-mk01","pulp-mill-mk01","hpf","washer","botanical-nursery"}
    for _,build in pairs(add_burn) do
      burners[#burners+1] = build
    end
    local ing_reps = {
      {name = "pulp-mill-mk01", old = "electric-mining-drill", new = "burner-mining-drill"},
      {name = "pulp-mill-mk01", old = "fbreactor-mk01", new = "clay-pit-mk01"},
      {name = "micro-mine-mk01", old = "electric-mining-drill", new = "burner-mining-drill"},
      {name = "micro-mine-mk01", old = "inserter", new = "burner-inserter"},
      {name = "botanical-nursery", old = "electric-mining-drill", new = "burner-mining-drill"},
      {name = "sap-extractor-mk01", old = "inserter", new = "burner-inserter"},
      {name = "agar", old = "steam", new = "coal-gas"},
      {name = "latex", old = "steam", new = "coal-gas"},

    }
    for _,ing in pairs(ing_reps) do
      replacements[#replacements+1] = ing
    end
  end

  if not mods["PyCoalTBaA"] then
    --add in a few custom tweaks if not playing angels or bobs
    if #replacements > 0 then
      for i,rep in pairs(replacements) do
        omni.lib.replace_recipe_ingredient(rep.name, rep.old, rep.new)
      end
    end
    if #burners > 0 then
      for _,ent in pairs(burners) do
        if data.raw["assembling-machine"][ent] and data.raw["assembling-machine"][ent].energy_source then
        data.raw["assembling-machine"][ent].energy_source = {
          type = "burner",
          fuel_category = "omnite",
          effectivity = 1,
          fuel_inventory_size = 1,
          emissions_per_minute = 0.06,
          }
        end
      end
    end
  end
end