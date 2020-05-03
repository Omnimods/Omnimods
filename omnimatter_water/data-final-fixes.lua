if settings.startup["omniwater-integrate"].value then
	for i=2,settings.startup["omnimatter-max-tier"].value do
		if data.raw.technology["omnitech-water-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-1)] then
			omni.lib.add_prerequisite("omnitractor-electric-"..i,"omnitech-water-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-1))
		end
		if i>2 and data.raw.technology["omnitech-water-viscous-mud-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-2)] then
			omni.lib.add_prerequisite("omnitractor-electric-"..i,"omnitech-water-viscous-mud-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-2))
		end
		if i > 2 then
			--log("add absolute garbage")
			for _,fluid in pairs(data.raw.fluid) do
				if omni.lib.start_with(fluid.name,"water") and omni.lib.end_with(fluid.name,"waste") then
					if data.raw.technology["omnitech-"..fluid.name.."-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-2)] then
						--omni.lib.add_prerequisite("omnitractor-electric-"..i,"omnitech-"..fluid.name.."-omnitraction-"..settings.startup["omnimatter-fluid-lvl-per-tier"].value*(i-2))
					end
				end
			end
		end
	end
end
if mods["aai-industry"] then
	data.raw["burner-generator"]["burner-turbine"].energy_source.effectivity=0.9/3
end

