RecGen:create("omnimatter","omnite-brick"):
	setIngredients("stone","omnite"):
	setCategory("omnifurnace"):
	setSubgroup("omni-solids"):
	setStacksize(200):
	setEnabled():
	tile():
	setPlace("omnite-brick"):extend()

RecGen:create("omnimatter","early-omnite-brick"):
	setIngredients({"omnite",10},{"stone-brick"}):
	setSubgroup("omni-solids"):
	setResults("omnite-brick"):
	setEnabled():extend()

local omnitile = table.deepcopy(data.raw.tile["stone-path"])
omnitile.name="omnite-brick"
omnitile.walking_speed_modifier = 1.5
omnitile.minable.result="omnite-brick"
omnitile.variants.main[1].picture="__omnimatter__/graphics/terrain/stone-path/stone-path-1.png"
omnitile.variants.main[1].hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-1.png"
omnitile.variants.main[2].picture="__omnimatter__/graphics/terrain/stone-path/stone-path-2.png"
omnitile.variants.main[2].hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-2.png"
omnitile.variants.main[3].picture="__omnimatter__/graphics/terrain/stone-path/stone-path-4.png"
omnitile.variants.main[3].hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-4.png"
omnitile.variants.inner_corner.picture="__omnimatter__/graphics/terrain/stone-path/stone-path-inner-corner.png"
omnitile.variants.inner_corner.hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-inner-corner.png"
omnitile.variants.outer_corner.picture="__omnimatter__/graphics/terrain/stone-path/stone-path-outer-corner.png"
omnitile.variants.outer_corner.hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-outer-corner.png"
omnitile.variants.side.picture="__omnimatter__/graphics/terrain/stone-path/stone-path-side.png"
omnitile.variants.side.hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-side.png"
omnitile.variants.u_transition.picture="__omnimatter__/graphics/terrain/stone-path/stone-path-u.png"
omnitile.variants.u_transition.hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-u.png"
omnitile.variants.o_transition.picture="__omnimatter__/graphics/terrain/stone-path/stone-path-o.png"
omnitile.variants.o_transition.hr_version.picture="__omnimatter__/graphics/terrain/stone-path/hr-stone-path-o.png"
data:extend({omnitile})