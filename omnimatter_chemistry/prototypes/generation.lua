

local ord={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r"}

local science_pack = {"science-pack-1","science-pack-2","omni-pack","science-pack-3","production-science-pack","high-tech-science-pack"}

added_techs={}

function omni.chem.add_chem(name, recipe, tech)
	local reg={}
	local ingredients = table.deepcopy(recipe.ingredients)
	math.randomseed(string.len(name)*recipe.max)
	local tname = tech.name
	if tech.name==nil then tname = name end
	added_techs[tname]=true
	for i=1, omni.chem.levels do	
		local res = {}

		local prod = recipe.max
		if recipe.total ~= nil then prod=recipe.total end
		local quant = prod*(recipe.start+(i-1)/(omni.chem.levels-1)*(1-recipe.start))
		
		local main_type = ""
		if data.raw.fluid[recipe.main] then main_type = "fluid" else main_type="item" end
		if main_type == "item" then
			local quant_int=math.floor(quant)
			local chance=quant-quant_int
			if chance>0 then
				res[#res+1]={type=main_type,amount=quant_int+1,name=recipe.main,probability=quant/(quant_int+1)}
			else
				res[#res+1]={type=main_type,amount=quant_int,name=recipe.main}
			end
		else
			res[#res+1]={type=main_type,amount=60*quant,name=recipe.main}
		end
		local total_waste = 0
		if recipe.waste == nil or #recipe.waste == 0 then
			recipe.waste = {{name="omnic-waste"}}
		end
		if i<omni.chem.levels or recipe.total ~= nil then
			for j,w in pairs(recipe.waste) do
				local waste_quant = 0
				if j ~= #recipe.waste then
					waste_quant=(recipe.max-quant-total_waste)/(#recipe.waste-j+1)*(0.9+0.2*math.random())
				else
					waste_quant=(recipe.max-quant-total_waste)
				end
				total_waste=total_waste+waste_quant
				local waste_int=math.floor(waste_quant)
				local waste_chance = waste_quant-waste_int
				local waste_type = "fluid"
				if data.raw.item[w.name] then waste_type="item" end
				if waste_chance>0 and waste_type == "item" then
					res[#res+1]={type=waste_type,amount=waste_int+1,name=w.name,probability=waste_quant/(waste_int+1)}
				elseif waste_type=="item" then
					res[#res+1]={type=waste_type,amount=waste_int,name=w.name}
				else
					res[#res+1]={type=waste_type,amount=60*waste_quant,name=w.name}
				end
			end
		end
		if mods["omnimatter_marathon"] then omni.marathon.exclude_recipe(name.."-"..ord[i]) end
		local loc_name = ""
		if recipe.loc_name then
			loc_name={"recipe-name.omni-recipe",recipe.loc_name}
		else
			loc_name = {main_type.."-name."..recipe.main}
		end
		reg[#reg+1]={
			type = "recipe",
			name = "omnirec-"..name.."-"..ord[i],
			icon_size = 32,
			enabled = false,
			localised_name=loc_name,
			energy_required = recipe.time,
			category=recipe.category,
			main_product=recipe.main,
			ingredients = ingredients,
			results = res,
		  }
		if type(tech)=="table" then
			local r = {}
			if i==1 then 
				local new_req  = {}
				for _, t in pairs(tech.req) do
					if added_techs[t] then
						new_req[#new_req+1]="omnitech-"..t.."-"..1
					elseif data.raw.technology["omnitech-"..t] then
						new_req[#new_req+1]="omnitech-"..t
					else
						new_req[#new_req+1]=t
					end
				end
				r=new_req
			else
				r={"omnitech-"..(tech.name or name).."-"..i-1}
			end
			
			local spacks = {}
			for j=1, math.min(math.floor((i-1)/omni.chem.pack+1)+(tech.pack or 0),#science_pack) do
				spacks[#spacks+1]={science_pack[j],1}
			end
			
			local split = omni.lib.split(tname,"-")
			local display = omni.lib.capitalize(split[1])
			for k=2,#split do
				display=display.." "..split[k]
			end
			display=display.." "..i
			
			reg[#reg+1]={
			type = "technology",
			name = "omnitech-"..tname.."-"..i,
			localised_name={"technology-name.omni-tech",display},
			icon = "__omnimatter_chemistry__/graphics/technology/"..tech.icon..".png",
			icon_size = 128,
			order = "z",
			effects = {
				{type = "unlock-recipe",
				recipe="omnirec-"..name.."-"..ord[i]},
			},
			upgrade = i>1,
			prerequisites = r,
			unit =
			{
				count = 50+(50)*(1+(tech.pack or 0))*i+math.pow(2,i),
				ingredients = spacks,
				time = 10+5*i
			}
			}
		else
			omni.lib.add_unlock_recipe("omnitech-"..tech.."-"..i,"omnirec-"..name.."-"..ord[i])
		end
		
	end
	data:extend(reg)
end