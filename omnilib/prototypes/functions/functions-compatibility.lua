function omni.lib.angels_component_patch()
  if mods['angelsindustries'] and angelsmods.industries.components then
    add_con_mats()
    replace_gen_mats()
    if angelsmods.industries.return_ingredients then
      add_minable_results()
    end
    angelsmods.functions.OV.execute()
  end
end