--Tech Overhaul setting is currently hidden and forced to false until compat is playable
if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value then
  -------------------------------------------------------------------------------
  -- GREY SCIENCE PACKS ---------------------------------------------------------
  -------------------------------------------------------------------------------
  --replace starting tech requirements to needing grey (not red)
  for _,tech_name in pairs({
    -- Omniwood
    "omnitech-omnialgae",
    "omnitech-omnimutator",
    --omnimatter
    "omnitech-base-impure-extraction",
    "omnitech-omnitractor-electric-1",
        "omnitech-omnitractor-electric-2",
        "omnitech-omnitractor-electric-3",
        "omnitech-omnitractor-electric-4",
        "omnitech-omnitractor-electric-5",
        "omnitech-omnitractor-electric-6",
  }) do
    if data.raw.technology[tech_name] then
            --NEEDS TO BE USED BEFORE THE FIRST ANALYSIS (DATA-UPDATES STAGE IS GOOD)
            --This is for techs which only have the data-analyser (no data-cores)
            angelsmods.functions.add_exception(tech_name) 
            
      --flat out set the pack instead of replacing NO SUBTLETY
      --[[data.raw.technology[tech_name].unit.ingredients = {
        {"angels-science-pack-grey",1},
        {"datacore-basic",2}
      }]]
    end
        --custom tweak for starting techs
      data.raw.technology["omnitech-base-impure-extraction"].unit.ingredients = {
        {"angels-science-pack-grey",1},
      }
  end
end