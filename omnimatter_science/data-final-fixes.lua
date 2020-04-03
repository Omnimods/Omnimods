require("prototypes.updates")
if mods["omnimatter_crystal"] then
	--UPDATE LABS INPUT
	for i, labs in pairs(data.raw["lab"]) do
	local found = false
	for i,v in ipairs(labs.inputs) do
		if v == "omni-pack" then
			log("XYZ"..labs.name)
			found = true
		end
	end
	
		if not lab_ignore_pack[labs.name] and not found then
			table.insert(labs.inputs, "omni-pack")
		end
	end
end

