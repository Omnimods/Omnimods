if mods["omnimatter_crystal"] then
	--UPDATE LABS INPUT
	for i, labs in pairs(data.raw["lab"]) do
		if not lab_ignore_pack[labs.name] then
			table.insert(labs.inputs, "omni-pack")
		end
	end
end
require("prototypes.updates")
