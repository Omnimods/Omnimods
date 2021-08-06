--Hide waste water setting without angels
if not mods["angelsrefining"] then
    omni.lib.hide_setting("bool-setting", "enable-waste-water")
end
