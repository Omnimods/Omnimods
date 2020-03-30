if not data.raw.item["stone-crushed"] then
data:extend(
{
  {
    type = "item",
    name = "stone-crushed",
    icon = "__base__/graphics/icons/stone.png",
    flags = {},
	subgroup = "omni-solids",
    icon_size = 32,
    stack_size = 200
  },
}
)
end

RecGen:create("omnimatter","stone"):
	setSubgroup("omni-solids"):
	setStacksize(200):
	setEnergy(0.5):
	setCategory():
	marathon():
	setIngredients({"stone-crushed", 2}):
	setResults({type="item", name="stone", amount=1}):
	setEnabled():
	extend()
