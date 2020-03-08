	require("recipe-functions")
	
	data.raw.resource["crude-oil"] = nil
	data.raw["autoplace-control"]["crude-oil"] = nil
	data.raw.resource["iron"] = nil
	data.raw["autoplace-control"]["iron"] = nil
	data.raw.resource["copper"] = nil
	data.raw["autoplace-control"]["copper"] = nil
	data.raw.resource["coal"] = nil
	data.raw["autoplace-control"]["coal"] = nil
	--data.raw["autoplace-control"]["infinite-omnite"] = nil
	
--ANGELS
	if angelsmods.refining then	
		data.raw.resource["angels-ore1"] = nil
		data.raw["autoplace-control"]["angels-ore1"] = nil
		
		data.raw.resource["angels-ore2"] = nil
		data.raw["autoplace-control"]["angels-ore2"] = nil
		
		data.raw.resource["angels-ore3"] = nil
		data.raw["autoplace-control"]["angels-ore3"] = nil
		
		data.raw.resource["angels-ore4"] = nil
		data.raw["autoplace-control"]["angels-ore4"] = nil
		
		data.raw.resource["angels-ore5"] = nil
		data.raw["autoplace-control"]["angels-ore5"] = nil

		data.raw.resource["angels-ore6"] = nil
		data.raw["autoplace-control"]["angels-ore6"] = nil
		
		data.raw.resource["angels-natural-gas"] = nil
		data.raw["autoplace-control"]["angels-natural-gas"] = nil
		
		data.raw.resource["angels-fissure"] = nil
		data.raw["autoplace-control"]["angels-fissure"] = nil
		
	end
	
	if data.raw["autoplace-control"]["infinite-angels-ore1"] then
		data.raw.resource["infinite-angels-ore1"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore1"] = nil
		data.raw.resource["infinite-angels-ore2"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore2"] = nil
		data.raw.resource["infinite-angels-ore3"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore3"] = nil
		data.raw.resource["infinite-angels-ore4"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore4"] = nil
		data.raw.resource["infinite-angels-ore5"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore5"] = nil
		data.raw.resource["infinite-angels-ore6"] = nil
		data.raw["autoplace-control"]["infinite-angels-ore6"] = nil
		data.raw.resource["infinite-coal"] = nil
		data.raw["autoplace-control"]["infinite-coal"] = nil
	end
	
	if data.raw.resource["lithium-brine"] and data.raw.resource["silicon-ore"] then
		data.raw.resource["lithium-brine"] = nil
		data.raw["autoplace-control"]["lithium-brine"] = nil
		
		data.raw.resource["silicon-ore"] = nil
		data.raw["autoplace-control"]["silicon-ore"] = nil
	end
	
	if data.raw.resource["tenemut"] then
		data.raw.resource["tenemut"] = nil
		data.raw["autoplace-control"]["tenemut"] = nil
	end
	