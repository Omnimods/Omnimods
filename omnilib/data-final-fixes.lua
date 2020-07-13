--check setting has actually been forced off
if mods["bobtech"] then
  settings.startup["bobmods-tech-colorupdate"].value = false
end

require("prototypes.override-angels-tech")

