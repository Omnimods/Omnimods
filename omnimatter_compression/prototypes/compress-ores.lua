local compressed_ores = {}

local blacklist = {{"creative","mode"}}--{"stone",{"creative","mode"}}

local add_fluid_boxes = false

local get_icons = function(item)
    --Build the icons table
    local icons = {}
    if item.icons then
        for _ , icon in pairs(item.icons) do
            local shrink = icon
			--local scale = icon.scale or 1
            --shrink.scale = scale*0.65
            icons[#icons+1] = shrink
        end
    else
        icons[#icons+1] = {icon = item.icon,icon_size=item.icon_size or 32}
    end
    return icons
end
local compensation_c = 500/120
for name,ore in pairs(data.raw.resource) do
	if not omni.lib.string_contained_list(name,blacklist) then
		if (ore.category == nil or ore.category == "basic-solid" or ore.category == "basic-fluid") and ore.name then
			local compressed = false
      local new = table.deepcopy(ore)

      new.localised_name = {"entity-name.compressed-ore",{"entity-name."..new.name}}
      new.name = "compressed-"..new.name.."-ore"
      if new.category == "basic-fluid" then
        new.name = "concentrated-" ..new.name --no need for ore in name      
      end
      if new.autoplace then new.autoplace = nil end

      if new.minable.results then
        local tempresults={}
        for _,res in pairs(new.minable.results) do
          if res.name == nil then
            local resname = res[1]
            local resct = res[2] or 1
            tempresults[#tempresults+1] = {
              amount_max = resct,
              amount_min = resct,
              name = resname,
              probability = 1,
              type = "item"
            }
          else
            tempresults[#tempresults+1] = res
          end
        end
        new.minable.results = tempresults
      elseif new.minable.result then
				new.minable.results = {{
					amount_max = 1,
					amount_min = 1,
					name = new.minable.result,
					probability = 1,
					type = "item"
				}}
				new.minable.result=nil
			end

      local max_stacksize = 0
      for i,drop in ipairs(new.minable.results) do
        
        for _,comp in pairs({"compressed-", "concentrated-"}) do

          if omni.lib.is_in_table(comp .. drop.name, compressed_item_names) then
            drop.name = comp .. drop.name
            compressed = true
            max_stacksize = math.max(omni.lib.find_stacksize(drop.name),max_stacksize) --returns 50 for fluids
          end
        end
			end
			new.minable.mining_time = tonumber(compensation_c*new.minable.mining_time*max_stacksize)
      if new.infinite then --just flat out clobber it by dropping yield by a factor of 3
				new.minimum = math.max(new.minimum/max_stacksize/3,1) --ensure at least 1
				new.normal = math.max(new.normal/max_stacksize/3,1) --ensure at least 1
				if new.maximum then new.maximum = new.maximum/max_stacksize/3 end
			end
			compressed = true
			if new.minable.required_fluid and data.raw.fluid[new.minable.required_fluid] then
				local ss = math.max(max_stacksize,1) --stop this from throwing a 0
				local t = "fluid"
				local a = 10*ss
				local n = new.minable.required_fluid
				local r = "concentrated-"..new.minable.required_fluid

				local cf = table.deepcopy(data.raw.fluid[n])
				cf.localised_name={"fluid-name.concentrated-fluid",{"fluid-name."..n}}
				cf.name = r
				compressed_ores[#compressed_ores+1] = cf
				if mods["omnimatter_fluid"] then
					t = "item"
					a = a/10
					n = "solid-"..n
					r = "solid-"..r
					local loc_key={"fluid-name.concentrated"}
					compressed_ores[#compressed_ores+1] = {
						type = "item",
						name = r,
						localised_name = {"item-name.solid-fluid", {"fluid-name."..new.minable.required_fluid}},
						icons = get_icons(data.raw.fluid[new.minable.required_fluid]),
						icon_size = 32,
						subgroup = "omni-solid-fluids",
						order = "a",
						stack_size = 200,
						flags={}
					}
					compressed_ores[#compressed_ores+1] = {
						type = "item",
						name = "compressed-"..r,
						localised_name = {"item-name.compressed-sluid", {"fluid-name."..new.minable.required_fluid}},
						icons = get_icons(data.raw.fluid[new.minable.required_fluid]),
						icon_size = 32,
						subgroup = "omni-solid-fluids",
						order = "a",
						stack_size = 50,
						flags={}
					}
					compressed_ores[#compressed_ores+1] = {
            type = "recipe",
            name = "liquify-"..r,
            icon = cf.icon,
            subgroup = "fluid-recipes",
            category = "general-omni-boiler",
            order = "g[hydromnic-acid]",
            icon_size = 32,
            energy_required = 3,
            enabled = true,
            ingredients =
            {
              {type = "item", name = r, amount = 10},
            },
            results =
            {
              {type = "fluid", name = "concentrated-"..new.minable.required_fluid, amount = 60*2.4},
            },
				  }
				  compressed_ores[#compressed_ores+1]={
            type = "recipe",
            name = "liquify-"..r.."-compression",
            icon = cf.icon,
            subgroup = "fluid-recipes",
            category = "general-omni-boiler",
            icon_size = 32,
            order = "g[hydromnic-acid]",
            energy_required = 3,
            enabled = true,
            ingredients =
            {
              {type = "item", name = "compressed-"..r, amount = 10},
            },
            results =
            {
              {type = "fluid", name = "concentrated-"..new.minable.required_fluid, amount = 3000*25/17.36*2.4},
            },
				  }
				  --data.raw.recipe["uncompress-solid-"..new.minable.required_fluid] = nil
				  concentrate = {
            type = "recipe",
            name = "concentrated-"..new.minable.required_fluid.."-compression",
            icons = data.raw.fluid[new.minable.required_fluid].icons,
            icon = data.raw.fluid[new.minable.required_fluid].icon,
            icon_size = 32,
            category = "fluid-concentration",
            enabled = true,
            hidden = true,
            ingredients = {
              {type = t,amount=a,name="compressed-"..n}
            },
            results = {
              {type=t,amount=5*a/ss,name = "compressed-"..r}
            },
            energy_required = 0.01,
          }
          compressed_ores[#compressed_ores+1]=concentrate
				else
					add_fluid_boxes=true
        end
        
				local concentrate = {
					type = "recipe",
					name = "concentrated-"..new.minable.required_fluid,
					icons = data.raw.fluid[new.minable.required_fluid].icons,
					icon = data.raw.fluid[new.minable.required_fluid].icon,
					icon_size = 32,
					category = "fluid-concentration",
					enabled = true,
					hidden = true,
					ingredients = {
						{type = t,amount=a,name=n}
					},
					results ={
						{type=t,amount=a/ss,name = r}
					},
					energy_required = 0.01,
				}
        compressed_ores[#compressed_ores+1]=concentrate
				new.minable.required_fluid="concentrated-"..new.minable.required_fluid
			end
			if compressed and max_stacksize > 0 then
        compressed_ores[#compressed_ores+1]=new
			end
		end
	end
end

if compressed_ores and #compressed_ores > 0 then
  data:extend(compressed_ores)
  
else
	--log("omnicompression didn't find any ores to extend, something is wrong.")
end
log("end ore compression")