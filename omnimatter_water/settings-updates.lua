--Force tech overhaul to be disabled and hide it until we provide a playable compat
if not mods["angelsrefining"] then
    omni.lib.hide_setting("bool-setting", "enable-waste-water")
end
