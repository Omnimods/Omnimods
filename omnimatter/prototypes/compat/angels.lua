if mods["angelsindustries"] and settings.startup["angels-enable-tech"].value == true then
	--add exceptions for tech
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-2")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore3-1")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-2")
	angelsmods.functions.add_exception("omnitech-focused-extraction-angels-ore1-1")
end