function omni.lib.angels_component_patch()
  if mods['angelsindustries'] and angelsmods.industries.components then
    angelsmods.functions.AI.add_con_mats()
    angelsmods.functions.AI.replace_gen_mats()
    if angelsmods.industries.return_ingredients then
      angelsmods.functions.AI.add_minable_results()
    end
    angelsmods.functions.OV.execute()
  end
end