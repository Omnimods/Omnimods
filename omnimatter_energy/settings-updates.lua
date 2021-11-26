if mods["bobtech"] then
    omni.lib.hide_setting("bool-setting", "bobmods-burnerphase", false)
end

--Disable and hide bobs burner electric generator (unlocked by default)
if mods["bobpower"] then
    omni.lib.hide_setting("bool-setting", "bobmods-power-burnergenerator", false)
end