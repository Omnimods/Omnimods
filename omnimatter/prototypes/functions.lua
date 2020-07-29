if not omni then omni = {} end

omnisource={}
tiercount={0,0,0}
omnifluid={}
uniomnitiers={}

phlog = false

function omni.add_resource(r,t,s,m)
	if not omnisource[tostring(t)] then omnisource[tostring(t)] = {} end
	omnisource[tostring(t)][r]={mod=m,tier = t, name = r,techicon = s}
end
function omni.add_fluid(r,t,q,s,m)
	if not omnifluid[tostring(t)] then omnifluid[tostring(t)] = {} end
	omnifluid[tostring(t)][r]={mod=m,tier = t,ratio=q, name = r,techicon = s}
end

function omni.add_omnicium_alloy(name,plate,ingot)
	local reg = {}
	ItemGen:create("omnimatter","omnicium-"..name.."-alloy"):
		setSubgroup("omnicium"):
		setStacksize(400):
		setIcons("omnicium-plate"):
		addSmallIcon(plate,3):extend()
	local r = RecGen:create("omnimatter","molten-omnicium-"..name.."-alloy")
		r:setReqAllMods("angelssmelting"):
		fluid():
		setBothColour({r = 1, g = 0, b = 1}):
		setMaxTemp(900):
		setIcons("liquid-molten-omnicium"):
		addSmallIcon(ingot,3):
		setCategory("induction-smelting"):
		setSubgroup("omnicium-casting"):
		setEnergy(4):
		setTechName("angels-omnicium-"..name.."-alloy-smelting"):
		setTechIcon("smelting-omnicium-"..name):
		setTechPacks("angels-"..name.."-smelting-1"):
		setTechCost(50):
		setTechTime(30):
		setTechPrereq(
			"angels-omnicium-smelting-1",
			"angels-"..name.."-smelting-1"):
		setIngredients(
			{type="item", name="ingot-omnicium", amount=18},
			{type="item", name=ingot, amount=12}
		):
		setResults({type="fluid", name="molten-omnicium-"..name.."-alloy", amount=300}):extend()
		
	RecGen:create("omnimatter","angels-plate-omnicium-"..name.."-alloy"):
		setReqAllMods("angelssmelting"):
		setCategory("casting"):
		setSubgroup("omnicium-casting"):
		setEnergy(4):
		addProductivity():
		setTechName("angels-omnicium-"..name.."-alloy-smelting"):
		setIngredients({type="fluid", name="molten-omnicium-"..name.."-alloy", amount=40}):
		addProductivity():
		setResults({type="item", name="omnicium-"..name.."-alloy", amount=4}):extend()
  if not mods["angelssmelting"] then
  	math.randomseed(string.len(plate..name))
	local metal_q = math.random(2,6)
	local omni_q = math.random(1,metal_q)
	reg[#reg+1]={
    type = "recipe",
    name = "omnicium-"..name.."-alloy-furnace",
    category = "omnifurnace",
	icon_size = 32,
    energy_required = 5,
	enabled = true,
    ingredients = {
		{type="item", name="omnicium-plate",amount=omni_q},
		{type="item", name=plate,amount=metal_q},
	},
    results = {{type="item", name="omnicium-"..name.."-alloy",amount=omni.lib.round(math.sqrt(omni_q+metal_q))}}
  }
  for _, tech in pairs(data.raw.technology) do
	if tech.effects then
		for _, eff in pairs(tech.effects) do
			if eff.type == "unlock-recipe" and eff.recipe == plate then
				table.insert(tech.effects,{type="unlock-recipe",recipe="omnicium-"..name.."-alloy-furnace"})
				break
			end
		end
	end
  end
  end
  if #reg > 0 then data:extend(reg) end
end