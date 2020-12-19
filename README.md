# Omnimods

## Join our Discord for questions & discussions
![Discord Banner 2](https://discordapp.com/api/guilds/351216213327609858/widget.png?style=banner2)

## Adding Omni compatibility to your mod:
- Add an ore to omnimatter (creates extraction recipes):
  - omni.add_resource(orename, tier)

- Add a fluid to omnimatter (creates extraction recipes):
  - omni.add_fluid(fluidname, tier, ratio)
  
- Remove an ore from omnimatter (no extraction recipes will be created):
  - omni.remove_resource(orename)

- Remove a fluid to omnimatter (no extraction recipes will be created):
  - omni.remove_fluid(fluidname) 

- Create an omnicium plate alloy recipe & item:
  - omni.add_omnicium_alloy(name,platename,ingredientname)
  
- Creates fluid extraction recipes & techs (omniwater --> fluid):
  - omni.add_omniwater_extraction(mod, element, lvls, tier, gain, starter_recipe)
