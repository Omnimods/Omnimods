local compressed_ores = {}

local blacklist = {{"creative","mode"}}--{"stone",{"creative","mode"}}

local add_fluid_boxes = false

local get_icons = omni.compression.find_result_icon
log("start ore compression")
local compensation_c = 500/120
for name,ore in pairs(data.raw.resource) do
  if not omni.lib.string_contained_list(name,blacklist) then
    if ore.name then
			local compressed = false
      local new = table.deepcopy(ore)
      new.localised_name = {
        "entity-name.compressed-ore",
        ore.localised_name or
        {"entity-name." .. ore.name}
      }
      if new.autoplace then new.autoplace = nil end
      local minable_type = "item"
      if new.minable.results then
        local minable_results = {}
        for _, result in pairs(new.minable.results) do
          if result.name == nil then
            local result_name = result[1]
            local result_count = result[2] or 1
            tempresults[#tempresults+1] = {
              amount_max = result_count,
              amount_min = result_count,
              name = result_name,
              probability = 1,
              type = "item"
            }
          else
            minable_type = result.type
            minable_results[#minable_results+1] = result
          end
        end
        new.minable.results = minable_results
      elseif new.minable.result then
				new.minable.results = {{
					amount_max = new.minable.count or 1,
					amount_min = new.minable.count or 1,
					name = new.minable.result,
					probability = 1,
					type = "item"
				}}
				new.minable.result=nil
      end
      if minable_type == "fluid" then
        new.name = "concentrated-resource-" ..new.name --no need for ore in name      
      else
        new.name = "compressed-resource-"..new.name
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
            icons = get_icons(data.raw.fluid[new.minable.required_fluid]),
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
					icons = get_icons(data.raw.fluid[new.minable.required_fluid]),
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
        --[[ Migrating to future properly named ores! hurray technical debt ]]--
        local new_copy = table.deepcopy(new)
        new_copy.name = ore.name
        new_copy.name = "compressed-"..new_copy.name.."-ore"
        if new.category == "basic-fluid" then
          new_copy.name = "concentrated-" ..new_copy.name --no need for ore in name      
        end
        compressed_ores[#compressed_ores+1] = new_copy
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