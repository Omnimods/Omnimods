--Force tech overhaul to be disabled and hide it until we provide a playable compat
if mods["angelsindustries"] and data.raw["bool-setting"]["angels-enable-tech"] then  
    omni.lib.hide_setting("bool-setting", "angels-enable-tech", false)
end

--Hide non functional Angels Refining settings (Dont need to force anything here)
if mods["angelsrefining"] then
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore1")
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore2")
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore3")
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore4")
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore5")
    omni.lib.hide_setting("bool-setting", "angels-starting-resource-ore6")
    omni.lib.hide_setting("double-setting", "angels-starting-resource-base")
end

if mods["bobores"] then
    omni.lib.hide_setting("bool-setting", "bobmods-ores-infiniteore")  
end