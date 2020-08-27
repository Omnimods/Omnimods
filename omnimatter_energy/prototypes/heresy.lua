-----------------------------------------------------------------------------
-- This is a file to allow the py mod sets to work with omnienergy ----------
-----------------------------------------------------------------------------
if mods["pyalienlife"] then
  omni.lib.replace_prerequisite("fluid-handling","automation-2", "anbaricity")
end
local replacements={
  {name= "micro-mine-mk01", old= "electric-miner" , new= "burner-miner"},
  {name= "micro-mine-mk01", old= "inserter" , new= "burner-inserter"}
}
--[[for i,rep in pairs(replacements) do
  omni.lib.replace_recipe_ingredient(rep.name, rep.old, rep.new)
end]]
