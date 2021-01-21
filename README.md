# Omnimods

## Join our Discord for questions & discussions
![Discord Banner 2](https://discordapp.com/api/guilds/351216213327609858/widget.png?style=banner2)

## Translations for all Omnimods can be found in this crowdin project. Help us to translate them into your language!
https://crowdin.com/project/factorio-mods-localization

## Adding Omni compatibility to your mod:

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
