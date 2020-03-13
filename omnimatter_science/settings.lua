data:extend(
{
  {
    type = "bool-setting",
    name = "omniscience-modify-costs",
    setting_type = "startup",
    default_value = true,
	order=a
  },
  {
    type = "bool-setting",
    name = "omniscience-modify-omnimatter-costs",
    setting_type = "startup",
    default_value = false,
	order=a
  },
  {
    type = "bool-setting",
    name = "omniscience-rocket-modified-by-omni",
    setting_type = "startup",
    default_value = true,
	order=a
  },
  {
    type = "bool-setting",
    name = "omniscience-cumulative-count",
    setting_type = "startup",
    default_value = true,
	order=a
  },
  {
    type = "double-setting",
    name = "omniscience-cumulative-constant",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.01,
	order=a
  },
  {
    type = "double-setting",
    name = "omniscience-chain-constant",
    setting_type = "startup",
    default_value = 0.75,
    minimum_value = 0.05,
	order=a
  },
  {
    type = "double-setting",
    name = "omniscience-chain-omnitech-constant",
    setting_type = "startup",
    default_value = 0.2,
    minimum_value = 0.005,
	order=a
  },
  {
    type = "double-setting",
    name = "omniscience-cumulative-constant-omni",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.01,
	order=a
  },
   {
    type = "bool-setting",
    name = "omniscience-exponential",
    setting_type = "startup",
    default_value = false,
	order=a
  },
  {
    type = "double-setting",
    name = "omniscience-exponential-initial",
    setting_type = "startup",
    default_value = 20,
    maximum_value = 2000,
    minimum_value = 20,
	order=a
  },
    {
    type = "double-setting",
    name = "omniscience-exponential-base",
    setting_type = "startup",
    default_value = 1,
    maximum_value = 6,
    minimum_value = 0.1,	
	order=a
  },
    {
    type = "double-setting",
    name = "omniscience-omnitech-max-constant",
    setting_type = "startup",
    default_value = 1.4,
    maximum_value = 6,
    minimum_value = 0.1,	
	order=a
  },
     {
    type = "bool-setting",
    name = "omniscience-standard-time",
    setting_type = "startup",
    default_value = false,
	order=a
  },
  {
    type = "int-setting",
    name = "omniscience-standard-time-constant",
    setting_type = "startup",
    default_value = 15,
    minimum_value = 5,
    maximum_value = 120,
	order=a
  },
}
)


