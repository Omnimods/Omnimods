# Omnimods

## Join our Discord for questions & discussions
![Discord Banner 2](https://discordapp.com/api/guilds/351216213327609858/widget.png?style=banner2)

## Translations for all Omnimods can be found in this crowdin project. Help us to translate them into your language!
https://crowdin.com/project/factorio-mods-localization

## Adding Omnimatter compatibility to your mod:
(All functions are provided in our data stage, extraction functions are executed in data-updates and autoplace removal in data-final-fixes)

- Add an ore to omnimatter (creates extraction recipes):
  - omni.matter.add_resource(orename, tier)

- Add a fluid to omnimatter (creates extraction recipes):
  - omni.matter.add_fluid(fluidname, tier, ratio)
  
- Remove an ore from omnimatter (no extraction recipes will be created):
  - omni.matter.remove_resource(orename)

- Remove a fluid from omnimatter (no extraction recipes will be created):
  - omni.matter.remove_fluid(fluidname)

- Create an omnicium plate alloy recipe & item:
  - omni.matter.add_omnicium_alloy(name,platename,ingredientname)
  
- Creates fluid extraction recipes & techs (omniwater --> fluid):
  - omni.matter.add_omniwater_extraction(mod, element, lvls, tier, gain, starter_recipe)

- Get the tier of an ore that is already added to omnimatter;
  - omni.matter.get_ore_tier(orename)

- Set the tier of an ore that is already added to omnimatter;
  - omni.matter.set_ore_tier(orename,tier)

- Add initial extraction (starter/burner) recipes for an ore:
  - omni.matter.add_initial(orename,ore_amount,omnite_amount)
  
- Add a resource to our autoplace removal blacklist (The resource will not be removed by us):
  - omni.matter.add_ignore_resource(name)
  
- Remove a resource from our autoplace removal blacklist:
  - omni.matter.remove_ignore_resource(name)
