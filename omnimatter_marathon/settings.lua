data:extend(
{
    {
    type = "bool-setting",
    name = "omnimarathon_exponential",
    setting_type = "startup",
    default_value = true,
	order=a
  },
  {
    type = "string-setting",
    name = "omnimarathon_constant",
    setting_type = "startup",
    default_value = "1/2",
	order=b
  },
  {
    type = "bool-setting",
    name = "omnimarathon_time_increase",
    setting_type = "startup",
    default_value = true,
	order=c
  },
  {
    type = "double-setting",
    name = "omnimarathon_time_const",
    setting_type = "startup",
    default_value = 0,
	order=e
  },
  {
    type = "bool-setting",
    name = "omnimarathon_adapt_fuel_value",
    setting_type = "startup",
    default_value = true,
	order=d
  },
  {
    type = "bool-setting",
    name = "omnimarathon_rounding",
    setting_type = "startup",
    default_value = false,
	order=f
  },
}
)


