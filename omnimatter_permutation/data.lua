if not omni then omni = {} end
if not omni.permutation then omni.permutation = {} end

omni.permutation.excluded_recipes = {}

data:extend({
    {
        type = "custom-input",
        name = "increase-input-fluid-rec",
        key_sequence = "CONTROL + SHIFT + I",
        consuming = "none"
    },{
        type = "custom-input",
        name = "decrease-input-fluid-rec",
        key_sequence = "CONTROL + ALT + I",
        consuming = "none"
    },
    {
        type = "custom-input",
        name = "increase-output-fluid-rec",
        key_sequence = "CONTROL + SHIFT + R",
        consuming = "none"
    },{
        type = "custom-input",
        name = "decrease-output-fluid-rec",
        key_sequence = "CONTROL + ALT + R",
        consuming = "none"
    },
})

function omni.permutation.exclude_recipe(recipe_name)
    omni.permutation.excluded_recipes[recipe_name] = true
end