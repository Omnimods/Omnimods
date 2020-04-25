game.reload_script()

for index, force in pairs(game.forces) do
  force.reset_recipes()
  force.reset_technologies()
  force.reset_technology_effects()
  if force.technologies["steam-power"].researched then
    force.recipes["burner-filter-inserter-2"].enabled = true
    force.recipes["burner-inserter-2"].enabled = true
  end
end