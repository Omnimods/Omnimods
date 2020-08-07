local water_levels = settings.startup["water-levels"].value

--Calc dynamic prereqs
local get_omniwater_prereq = function(grade,element,tier)
  local req = {}
  local tractor_lvl = ((grade-1)/omni.fluid_levels_per_tier)+tier-1 
  --Add previous tech as prereq if its in the same tier
	if grade > 1 and grade%omni.fluid_levels_per_tier~=1 then
		req[#req+1]="omnitech-"..element.."-omnitraction-"..(grade-1)
  end
  --Add an electric omnitractor tech as prereq if this is the first tech of a new tier
  if grade%omni.fluid_levels_per_tier == 1 and (tractor_lvl <=omni.max_tier) and (tractor_lvl >= 1)then
    req[#req+1]="omnitractor-electric-"..tractor_lvl
    --Add the last tech as prereq for this omnitractor tech
	  if (grade-1) > 0 then
      omni.lib.add_prerequisite("omnitractor-electric-"..tractor_lvl, "omnitech-"..element.."-omnitraction-"..(grade-1), true)
    end
  end
	return req
end

--Calc dynamic tech packs
local get_omniwater_tech_packs = function(grade,tier)
  local packs = {}
  local pack_tier = math.ceil(grade/omni.fluid_levels_per_tier) + tier-1
  for i=1,pack_tier do
		packs[#packs+1] = {omni.sciencepacks[i],1}
	end
	return packs
end

function omniwateradd(element,gain,tier,const,input,starter_recipe)
	local cost = OmniGen:create():
		setInputAmount(12*(input or 1)):
		setYield(element):
		setIngredients("omnite"):
		setWaste("omnic-waste"):
		--setLocName("fluid-name."..element):
		yieldQuant(function(levels,grade) return gain+(grade-1)*gain/(levels-1) end):
		wasteQuant(function(levels,grade) return gain-(grade-1)*gain/(levels-1) end)
	--log("making omniwater "..element)
	RecChain:create("omnimatter_water",element):
		setIngredients("omnite"):
		setIcons(element):
		setIngredients(cost:ingredients()):
		setResults(cost:results()):
		setEnabled(false):
		setCategory("omnite-extraction-both"):
    setSubgroup("omni-fluid-extraction"):
    setOrder("z[water-waste-omnitraction-"..element):
		setLocName("recipe-name.water-waste-omnitraction",{"fluid-name."..element}):
		setLevel(water_levels):
		setEnergy(5*(input or 1)):
		setTechIcon("omnimatter_water",element):
		setTechSuffix("omnitraction"):
		setTechPrereq(function(levels,grade) return get_omniwater_prereq(grade,element,tier) end):
    setTechPacks(function(levels,grade) return get_omniwater_tech_packs(grade,tier) end):
    setTechCost(function(levels,grade) return const*get_tier_mult(levels,grade,1) end):
		setTechTime(15):
		setTechLocName("water-based-omnitraction",{"fluid-name."..element}):
		extend()

  --Add the last tier as prereq for the rocket silo
  omni.lib.add_prerequisite("rocket-silo", "omnitech-"..element.."-omnitraction-"..water_levels)

  --Add starter recipe with lower yield if enabled
  if starter_recipe == true then
    RecGen:create("omnimatter_water","basic-"..element.."-omnitraction"):
      setIcons(element):
      addSmallIcon("__omnilib__/graphics/icons/small/num_1.png", 2):
      setIngredients({type = "item", name = "omnite", amount = 12}):
      setResults({
        {type = "fluid", name = element, amount = gain*0.5},
        {type = "fluid", name = "omnic-waste", amount = gain*2}}):
      setSubgroup("omni-fluid-basic"):
      setOrder("b[basic-"..element.."-omnitraction]"):
      setCategory("omnite-extraction-both"):
      setLocName("recipe-name.basic-water-waste-omnitraction",{"fluid-name."..element}):
      setEnergy(5):
      setEnabled(true):
      extend()
    end
end

local c = 1
if mods["omnimatter_compression"] then c = 1/3 end
omniwateradd("omnic-water",1728*2*c,1,18,c,true)

if mods["angelsrefining"] then
	omniwateradd("water-viscous-mud",1728/2,1,36,false)
	for _,fluid in pairs(data.raw.fluid) do
		if omni.lib.start_with(fluid.name,"water") and omni.lib.end_with(fluid.name,"waste") then
			omniwateradd(fluid.name,1728/6,2,54,false)
		end
	end
end


--AAI compat, not sure if outdated or not
if mods["aai-industry-sp0"] then
  industry.add_tech("omniwaste")
  
  RecGen:create("omnimatter_water","water-extraction"):
    setIcons("__base__/graphics/icons/fluid/water.png"):
    setIngredients({type = "fluid", name = "omnic-waste", amount = 200}):
    setResults({type = "fluid", name = "water", amount=150}):
    setCategory("omniphlog"):
    setSubgroup("omni-fluids"):
    setEnergy(5):
    setEnabled(false):
    setTechName("omniwaste"):
    extend()
end



