if not omni then omni = {} end
if not omni.lib then omni.lib = {} end

--Hides a setting and sets forced_value if specified
--setting_type: bool-setting , int-setting , double-setting , string-setting
function omni.lib.hide_setting(setting_type, setting_name, forced_value)
    if data.raw[setting_type] and data.raw[setting_type][setting_name] then
        data.raw[setting_type][setting_name].hidden = true
        if forced_value ~= nil then
            if setting_type == "bool-setting" then
                data.raw[setting_type][setting_name].forced_value = forced_value
            else
                data.raw[setting_type][setting_name].default_value = forced_value
                data.raw[setting_type][setting_name].allowed_values = {forced_value}
            end
        end
    end
end

if mods["bobtech"] then
    omni.lib.hide_setting("bool-setting", "bobmods-tech-colorupdate", false)
end