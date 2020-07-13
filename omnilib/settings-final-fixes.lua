local function hide_setting(setting_type, setting_name, setting_default)
  if data.raw[setting_type] and data.raw[setting_type][setting_name] then
    if setting_default ~= nil then
      data.raw[setting_type][setting_name].default_value = setting_default
    end
    data.raw[setting_type][setting_name].hidden = true
  end
end

if mods["bobtech"] then

  hide_setting("bool-setting", "bobmods-tech-colorupdate", false)
  
end