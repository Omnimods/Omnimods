if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value then
  -------------------------------------------------------------------------------
  -- GREY SCIENCE PACKS ---------------------------------------------------------
  -------------------------------------------------------------------------------
  --replace starting tech requirements to needing grey (not red)
  for _,tech_name in pairs({
    -- Omniwood
    "omnialgae",
    "omnimutator",
    --omnimatter
    "base-impure-extraction",
    "omnitractor-electric-1",
    "omnitech-omnic-acid-hydrolyzation-1",
    "omnitech-omnisolvent-omnisludge-1",
    "omnitech-focused-extraction-angels-ore3-2",
    "omnitech-focused-extraction-angels-ore3-1",
    "omnitech-focused-extraction-angels-ore1-2",
    "omnitech-focused-extraction-angels-ore1-1",
  }) do
    if data.raw.technology[tech_name] then
      --flat out set the pack instead of replacing NO SUBTLETY
      data.raw.technology[tech_name].unit.ingredients={
        {"angels-science-pack-grey",1},
        {"datacore-basic",2}
      }
    end
  end
end
