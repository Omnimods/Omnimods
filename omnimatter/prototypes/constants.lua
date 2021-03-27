--Set constants
omni.max_tier = settings.startup["omnimatter-max-tier"].value
omni.pure_levels_per_tier = settings.startup["omnimatter-pure-lvl-per-tier"].value
omni.impure_levels = settings.startup["omnimatter-impure-lvls"].value
omni.fluid_levels_per_tier = settings.startup["omnimatter-fluid-lvl-per-tier"].value
omni.fluid_levels = settings.startup["omnimatter-fluid-lvl"].value
omni.pure_tech_tier_increase = settings.startup["omnimatter-pure-tech-tier-cost-increase"].value
omni.pure_tech_level_increase = settings.startup["omnimatter-pure-tech-level-cost-increase"].value
omni.beginning_tech_help = settings.startup["omnimatter-beginner-multiplier"].value
omni.acid_ratio = 1/1--9/13
omni.sludge_ratio = 1/1--8/15
omni.omniston_ratio = 1/1
omni.linear_science = settings.startup["omnimatter-linear-science-packs"].value
omni.science_constant = settings.startup["omnimatter-science-pack-constant"].value
omni.rocket_locked = settings.startup["omnimatter-rocket-locked"].value

if omni.linear_science and omni.science_constant < 1 then omni.science_constant = 1 end

--constant functions
function omni.matter.get_constant(kind)
	if kind == "acid" then
		return omni.acid_ratio
	elseif kind == "fluid level" then
		return omni.fluid_levels 
	end
end

function omni.matter.get_ore_production(level)
	return (-13+24*omni.pure_levels_per_tier+5*lvl)/(-1+3*omni.pure_levels_per_tier)*(-4+9*omni.pure_levels_per_tier+lvl)/(-4+12*omni.pure_levels_per_tier)
end

function omni.matter.get_fluid_production(level,fluid)
	local lvl_amount = (120+(level-1)*120/(omni.fluid_levels-1))
	if fluid == "omnic acid" then
		lvl_amount=lvl_amount*omni.acid_ratio
	elseif fluid == "omni sludge" then
		lvl_amount=lvl_amount*omni.sludge_ratio
	end
	return lvl_amount
end