if mods["Bio_Industries"] then
	if not mods["bobgreenhouse"] then
		ItemGen:create("omnimatter_wood","omniseedling"):
			setFuelValue(1):
			setSubgroup("omnimutator-items"):
			setStacksize(100):extend()
	end
	omni.lib.replace_recipe_result("bi_recipe_seedling_mk1","seedling",{"omniseedling",40})
	data.raw.recipe["bi_recipe_seedling_mk1"].icon=nil
	data.raw.recipe["bi_recipe_seedling_mk1"].icons={
		{icon="__omnimatter_wood__/graphics/icons/Seedling.png"},
		{icon="__base__/graphics/icons/fluid/water.png",
		scale = 0.4375,
		shift = { 10, 10},}
		}
	data.raw.recipe["bi_recipe_seedling_mk1"].category="omnimutator"
	omni.lib.replace_recipe_result("bi_recipe_seedling_mk2","seedling",{"omniseedling",60})
	data.raw.recipe["bi_recipe_seedling_mk2"].icon=nil
	data.raw.recipe["bi_recipe_seedling_mk2"].icons={
		{icon="__omnimatter_wood__/graphics/icons/Seedling.png"},
		{icon="__Bio_Industries__/graphics/icons/ash.png",
		scale = 0.4375,
		shift = { 10, 10},}
		}
	data.raw.recipe["bi_recipe_seedling_mk2"].category="omnimutator"
	omni.lib.replace_recipe_result("bi_recipe_seedling_mk3","seedling",{"omniseedling",90})
	data.raw.recipe["bi_recipe_seedling_mk3"].icon=nil
	data.raw.recipe["bi_recipe_seedling_mk3"].icons={
		{icon="__omnimatter_wood__/graphics/icons/Seedling.png"},
		{icon="__Bio_Industries__/graphics/icons/fertiliser_32.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	data.raw.recipe["bi_recipe_seedling_mk3"].category="omnimutator"
	omni.lib.replace_recipe_result("bi_recipe_seedling_mk4","seedling",{"omniseedling",160})
	data.raw.recipe["bi_recipe_seedling_mk4"].icon=nil
	data.raw.recipe["bi_recipe_seedling_mk4"].icons={
		{icon="__omnimatter_wood__/graphics/icons/Seedling.png"},
		{icon="__Bio_Industries__/graphics/icons/advanced_fertiliser_32.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	data.raw.recipe["bi_recipe_seedling_mk4"].category="omnimutator"
	
	omni.lib.replace_recipe_result("bi_recipe_logs_mk1","wood",{"omniwood",60})
	data.raw.recipe["bi_recipe_logs_mk1"].icon=nil
	data.raw.recipe["bi_recipe_logs_mk1"].icons={
		{icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png"},
		{icon="__base__/graphics/icons/fluid/water.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	omni.lib.replace_recipe_ingredient("bi_recipe_logs_mk1","seedling","omniseedling")
	
	omni.lib.replace_recipe_result("bi_recipe_logs_mk2","wood",{"omniwood",100})
	data.raw.recipe["bi_recipe_logs_mk2"].icon=nil
	data.raw.recipe["bi_recipe_logs_mk2"].icons={
		{icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png"},
		{icon="__Bio_Industries__/graphics/icons/ash.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	
	omni.lib.replace_recipe_ingredient("bi_recipe_logs_mk2","seedling","omniseedling")
	
	omni.lib.replace_recipe_result("bi_recipe_logs_mk3","wood",{"omniwood",150})
	data.raw.recipe["bi_recipe_logs_mk3"].icon=nil
	data.raw.recipe["bi_recipe_logs_mk3"].icons={
		{icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png"},
		{icon="__Bio_Industries__/graphics/icons/fertiliser_32.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	
	omni.lib.replace_recipe_ingredient("bi_recipe_logs_mk3","seedling","omniseedling")
	
	omni.lib.replace_recipe_result("bi_recipe_logs_mk4","wood",{"omniwood",400})
	data.raw.recipe["bi_recipe_logs_mk4"].icon=nil
	data.raw.recipe["bi_recipe_logs_mk4"].icons={
		{icon="__omnimatter_wood__/graphics/icons/mutated-wood2.png"},
		{icon="__Bio_Industries__/graphics/icons/advanced_fertiliser_32.png",
		scale = 0.4375,
		shift = { 10, 10},}
	}
	
	omni.lib.replace_recipe_ingredient("bi_recipe_logs_mk4","seedling","omniseedling")
	
	omni.lib.add_prerequisite("bi_tech_bio_farming", "omnimutator") 
end