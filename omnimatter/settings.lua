data:extend({
  {
    type = "bool-setting",
    name = "omnimatter-infinite-omnic-acid",
    setting_type = "startup",
    default_value = true,
    order = "ab"
  },
  {
    type = "double-setting",
    name = "omnimatter-beginner-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.20,
    maximum_value = 5,
    order = "ac"
  },
  {
    type = "int-setting",
    name = "omnimatter-max-tier",
    setting_type = "startup",
    default_value = 5,
    minimum_value = 3,
    maximum_value = 8,
    allowed_values = {3,4,5,6,7,8},
    order = "ad"
  },
  {
    type = "int-setting",
    name = "omnimatter-pure-lvl-per-tier",
    setting_type = "startup",
    default_value = 2,
    minimum_value = 1,
    maximum_value = 6,
    allowed_values = {1,2,3,4,5,6},
    order = "ae"
  },
  {
    type = "int-setting",
    name = "omnimatter-impure-lvls",
    setting_type = "startup",
    default_value = 3,
    minimum_value = 2,
    maximum_value = 6,
    allowed_values = {2,3,4,5,6},
    order = "af"
  },
  {
    type = "int-setting",
    name = "omnimatter-fluid-lvl",
    setting_type = "startup",
    default_value = 6,
    minimum_value = 2,
    maximum_value = 10,
    allowed_values = {2,3,4,5,6,7,8,9,10},
    order = "ag"
  },
  {
    type = "int-setting",
    name = "omnimatter-fluid-lvl-per-tier",
    setting_type = "startup",
    default_value = 2,
    minimum_value = 1,
    maximum_value = 3,
    allowed_values = {1,2,3},
    order = "ah"
  },
  {
    type = "double-setting",
    name = "omnimatter-pure-tech-tier-cost-increase",
    setting_type = "startup",
    default_value = 2,
    minimum_value = 1.0,
    maximum_value = 5,
    order = "ai"
  },
  {
    type = "double-setting",
    name = "omnimatter-pure-tech-level-cost-increase",
    setting_type = "startup",
    default_value = 0.3,
    minimum_value = 0.0001,
    maximum_value = 20,
    order = "aj"
  },
  {
    type = "bool-setting",
    name = "omnimatter-linear-science-packs",
    setting_type = "startup",
    default_value = false,
    order = "ak"
  },
  {
    type = "double-setting",
    name = "omnimatter-science-pack-constant",
    setting_type = "startup",
    default_value = 2,
    minimum_value = 0.00,
    maximum_value = 10,
    order = "al"
  },
  {
    type = "bool-setting",
    name = "omnimatter-rocket-locked",
    setting_type = "startup",
    default_value = true,
    order = "am"
  },
  {
    type = "bool-setting",
    name = "omnimatter-fluid-processing",
    setting_type = "startup",
    default_value = true,
    order = "an"
  },
})