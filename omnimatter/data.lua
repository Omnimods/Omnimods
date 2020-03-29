--INITIALIZE
if not zemods then zemods = {} end
if not omnimatter then omnimatter = {} end
if not omni then omni = {} end
require("functions")

require("config")

require("prototypes.constants")



if omni.pure_dependency > omni.pure_levels_per_tier then omni.pure_dependency = omni.pure_levels_per_tier end
if omni.impure_dependency > omni.impure_levels_per_tier then omni.impure_dependency = omni.impure_levels_per_tier end
if omni.fluid_dependency > omni.fluid_levels_per_tier then omni.fluid_dependency = omni.fluid_levels_per_tier end

--Infinite ore result probability check
--LOAD PROTOTYPES
require("prototypes.stone")
require("prototypes.omniore")
require("prototypes.generation.omnite-inf")
require("prototypes.generation.omnite")
require("prototypes.categories")
require("prototypes.recipes.omnicium")

--require("prototypes.generation.omniston")
--require("prototypes.localization-override")

function get_tier_mult(levels,r,c)
	local peak = math.floor(levels/2)+1
	if r==1 and c==1 then
		return 1
	elseif r==c and r<=peak then
		return omni.pure_tech_level_increase
	elseif r>peak and c==2*peak-r+levels%2 then
		return -omni.pure_tech_level_increase
	else
		local val = get_tier_mult(levels,r-1,c)+get_tier_mult(levels,r,c+1)
		return val
	end
end

function get_acid_tech_cost(lvl)
	local c = {}
	local size = 1+((lvl-1)-(lvl-1)%omni.fluid_levels_per_tier)/omni.fluid_levels_per_tier
	local length = math.min(size,#omni.sciencepacks)
	for l=1,length do
		local q = 0
		if omni.linear_science then
			q = 1+omni.science_constant*(size-l)
		else
			q=omni.lib.round(math.pow(omni.science_constant,size-l))
		end
		c[#c+1] = {omni.sciencepacks[l],q}
	end
	return length
end

local get_omnic_req=function(lvl)
	local req = {}
	if (lvl-1)%omni.fluid_levels_per_tier == 0 then
		req[#req+1]="omnitractor-electric-"..math.min((lvl-1)/omni.fluid_levels_per_tier+1,5)
		if lvl > 1 and omni.fluid_dependency < omni.fluid_levels_per_tier then
			req[#req+1]="omnitech-omnic-acid-hydrolyzation-"..(lvl-1)
		end
	else
		req[#req+1]="omnitech-omnic-acid-hydrolyzation-"..(lvl-1)
	end
	return req
end

local quant = 24
local omniFluidCat = "chemistry"
if mods["omnimatter_crystal"] then omniFluidCat = "omniplant" end
local water = "omnic-water"
if mods["angelsrefining"] then water = "water-purified" end

cost = OmniGen:create():
		setYield("omnic-acid"):
		setIngredients("omnite"):
		setWaste():
		yieldQuant(function(levels,grade) return omni.acid_ratio*(120+(grade-1)*120/(levels-1)) end ):
		wasteQuant(function(levels,grade) return math.max(12-extraction_value(levels,grade),0) end)
local omnic_acid = RecChain:create("omnimatter","omnic-acid"):
		setLocName("fluid-name.omnic-acid"):
		setIngredients({
		{name = "crushed-omnite", amount = quant/2},
		{type="fluid", name=water, amount=120},
		{type="fluid", name="steam", amount=120},
		}):
		setCategory(omniFluidCat):
		setSubgroup("omni-fluids"):
		setLevel(omni.fluid_levels):
		setResults(cost:results()):
		setEnergy(function(levels,grade) return 3 end):
		setTechSuffix("hydrolyzation"):
		setTechIcon("omnimatter","omnic-acid"):
		setTechCost(function(levels,grade) return 25*get_tier_mult(levels,grade,1) end):
		setTechPacks(function(levels,grade) return get_acid_tech_cost(grade) end):
		setTechPrereq(function(levels,grade) return get_omnic_req(grade)  end):
		setTechLocName("omnic-acid"):
		setTechTime(15):
		extend()

		BuildGen:create("omnimatter","omniphlog"):
		setBurner(0.75,1):
		setStacksize(10):
		setSubgroup("omniphlog"):
		setReplace("omniphlog"):
		setSize(3):
		setCrafting("omniphlog"):
		setFluidBox("XWX.XXX.XKX"):
		setUsage(300):
		setAnimation({
		layers={
		{
			filename = "__omnimatter__/graphics/entity/buildings/omniphlog.png",
			priority = "extra-high",
			width = 160,
			height = 160,
			frame_count = 36,
			line_length = 6,
			shift = {0.00, -0.05},
			scale = 0.90,
			animation_speed = 0.5
		},
		}
		}):
		setIngredients({
		  {type = "item", name = "omnicium-plate", amount = 10},
		  {type = "item", name = "omnicium-gear-wheel", amount = 15},
		  {type = "item", name = "iron-plate", amount = 10},
		  {type = "item", name = "copper-plate", amount = 5},
		}):setEnabled():extend()
