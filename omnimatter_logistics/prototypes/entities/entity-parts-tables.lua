--check declared correctly
if not omni.logistics then omni.logistics={} end
--flying sounds
function omni.logistics.flying_robot(volume)
	return {
		sound = {
			{filename = "__base__/sound/flying-robot-1.ogg", volume = volume},
			{filename = "__base__/sound/flying-robot-2.ogg", volume = volume},
			{filename = "__base__/sound/flying-robot-3.ogg", volume = volume},
			{filename = "__base__/sound/flying-robot-4.ogg", volume = volume},
			{filename = "__base__/sound/flying-robot-5.ogg", volume = volume},
		},
		max_sounds_per_type = 5,
		audible_distance_modifier = 1,
		probability = 1 / (10 * 60) -- average pause between the sound is 10 seconds
	}
end
--cargo robot parts
omni.logistics.cargo_bot_images={
  idle ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
    priority = "high",
    line_length = 16,
    width = 128,
    height = 128,
    scale = 0.5,
    frame_count = 1,
    shift = {0, 0},
    direction_count = 16,
    y = 128
  },
  idle_with_cargo ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
    priority = "high",
    line_length = 16,
    width = 128,
    height = 128,
    scale = 0.5,
    frame_count = 1,
    shift = {0, 0},
  --scale = 0.5,
    direction_count = 16,
  },
  in_motion ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
    priority = "high",
    line_length = 16,
    width = 128,
    height = 128,
    scale = 0.5,
    frame_count = 1,
    shift = {0, 0},
  --scale = 0.5,
    direction_count = 16,
    y = 384
  },
  in_motion_with_cargo ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot.png",
    priority = "high",
    line_length = 16,
    width = 128,
    height = 128,
    scale = 0.5,
    frame_count = 1,
    shift = {0, 0},
  --scale = 0.5,
    direction_count = 16,
    y = 256
  },
  shadow_idle ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
    direction_count = 16,
  },
  shadow_idle_with_cargo ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
    direction_count = 16
  },
  shadow_in_motion ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
    direction_count = 16,
  },
  shadow_in_motion_with_cargo ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-robot/cargo-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
    direction_count = 16
  },
}
--construction bot parts
omni.logistics.construction_bot_parts={

  shadow_idle ={
    filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
	  scale = 0.75,
    direction_count = 16
  },
  shadow_in_motion ={
    filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
    priority = "high",
    line_length = 16,
    width = 64,
    height = 64,
    frame_count = 1,
    shift = {0, 0},
	  scale = 0.75,
    direction_count = 16
  },
  shadow_working ={
    stripes = util.multiplystripes(2,{
        {
		      filename = "__omnimatter_logistics__/graphics/entity/construction-robot/construction-robot-shadow.png",
          width_in_frames = 16,
          height_in_frames = 1,
        }
      }),
    priority = "high",
    width = 64,
    height = 64,
    frame_count = 2,
    shift = {0, 0},
    direction_count = 16
  },
  smoke ={
    filename = "__base__/graphics/entity/smoke-construction/smoke-01.png",
    width = 39,
    height = 32,
    frame_count = 19,
    line_length = 19,
    shift = {0.078125, -0.15625},
    animation_speed = 0.3,
  },
  sparks ={
    {
      filename = "__base__/graphics/entity/sparks/sparks-01.png",
      width = 39,
      height = 34,
      frame_count = 19,
      line_length = 19,
      shift = {-0.109375, 0.3125},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
    {
      filename = "__base__/graphics/entity/sparks/sparks-02.png",
      width = 36,
      height = 32,
      frame_count = 19,
      line_length = 19,
      shift = {0.03125, 0.125},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
    {
      filename = "__base__/graphics/entity/sparks/sparks-03.png",
      width = 42,
      height = 29,
      frame_count = 19,
      line_length = 19,
      shift = {-0.0625, 0.203125},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
    {
      filename = "__base__/graphics/entity/sparks/sparks-04.png",
      width = 40,
      height = 35,
      frame_count = 19,
      line_length = 19,
      shift = {-0.0625, 0.234375},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
    {
      filename = "__base__/graphics/entity/sparks/sparks-05.png",
      width = 39,
      height = 29,
      frame_count = 19,
      line_length = 19,
      shift = {-0.109375, 0.171875},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
    {
      filename = "__base__/graphics/entity/sparks/sparks-06.png",
      width = 44,
      height = 36,
      frame_count = 19,
      line_length = 19,
      shift = {0.03125, 0.3125},
      tint = { r = 1.0, g = 0.9, b = 0.0, a = 1.0 },
      animation_speed = 0.3,
    },
  },
}
--vanilla roboports
omni.logistics.roboport_parts={
  charging_offsets =
  {
    {-1.5, -0.5}, {1.5, -0.5}, {1.5, 1.5}, {-1.5, 1.5},
  },
  base =
  {
    filename = "__omnimatter_logistics__/graphics/entity/omni-roboport-base.png",
    width = 143,
    height = 135,
    shift = {0.5, 0.25}
  },
  base_patch =
  {
    filename = "__omnimatter_logistics__/graphics/entity/omni-roboport-base-patch.png",
    priority = "medium",
    width = 69,
    height = 50,
    frame_count = 1,
    shift = {0.03125, 0.203125}
  },
  base_animation =
  {
    filename = "__base__/graphics/entity/roboport/roboport-base-animation.png",
    priority = "medium",
    width = 42,
    height = 31,
    frame_count = 8,
    animation_speed = 0.5,
    shift = {-0.5315, -1.9375}
  },
  door_animation_up =
  {
    filename = "__base__/graphics/entity/roboport/roboport-door-up.png",
    priority = "medium",
    width = 52,
    height = 20,
    frame_count = 16,
    shift = {0.015625, -0.890625}
  },
  door_animation_down =
  {
    filename = "__base__/graphics/entity/roboport/roboport-door-down.png",
    priority = "medium",
    width = 52,
    height = 22,
    frame_count = 16,
    shift = {0.015625, -0.234375}
  },
  recharging_animation =
  {
    filename = "__base__/graphics/entity/roboport/roboport-recharging.png",
    priority = "high",
    width = 37,
    height = 35,
    frame_count = 16,
    scale = 1.5,
    animation_speed = 0.5
  },
  working_sound =
  {
    sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.6 },
    max_sounds_per_type = 3,
    audible_distance_modifier = 0.5,
    probability = 1 / (5 * 60) -- average pause between the sound is 5 seconds
  },
  open_door_trigger_effect =
  {
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
    },
  },
  close_door_trigger_effect =
  {
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
    },
  }
}
--zone expanders
omni.logistics.zone_expander_parts={
  base ={
    filename = "__omnimatter_logistics__/graphics/entity/zone-expander/zone-expander-base.png",
    width = 128,
    height = 224,
    shift = {0.25, -1},
    scale = 0.5,
  },
  base_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/zone-expander/zone-expander.png",
    priority = "medium",
    width = 128,
    height = 224,
    frame_count = 16,
    line_length = 4,
    shift = {0.25, -1},
    scale = 0.5,
    animation_speed = 0.5
  },
	base_patch ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
	door_animation ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  door_animation_up ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  door_animation_down ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  recharging_animation ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
}
--relay stations
omni.logistics.relay_station_parts = {
  base ={
    filename = "__omnimatter_logistics__/graphics/entity/relay-station/relay-station-base.png",
    width = 128,
    height = 224,
    shift = {0.25, -1},
	  scale = 0.5,
  },
	base_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/relay-station/relay-station.png",
    priority = "medium",
    width = 128,
    height = 224,
    frame_count = 16,
	  line_length = 4,
    shift = {0.25, -1},
	  scale = 0.5,
	  animation_speed = 0.5
  },
	base_patch ={
    filename = "__omnilib__/graphics/icons/blank.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
	door_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  door_animation_up ={
    filename = "__omnimatter_logistics__/graphics/entity/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  door_animation_down ={
    filename = "__omnimatter_logistics__/graphics/entity/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
  },
  recharging_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/empty.png",
    width = 1,
    height = 1,
    frame_count = 1,
  }
}
--construction roboport
omni.logistics.construction_port_parts={
  charging_offsets ={
    {-1.5, -2.5}, {1.5, -2.5},
  },
  base ={
    filename = "__omnimatter_logistics__/graphics/entity/construction-roboport/construction-roboport.png",
    width = 256,
    height = 256,
    shift = {0.5, -0.75}
  },
  base_patch ={
    filename = "__omnimatter_logistics__/graphics/entity/construction-roboport/construction-roboport-patch.png",
    priority = "medium",
    width = 96,
    height = 96,
    frame_count = 1,
    shift = {0, -0.75}
  },
  base_animation ={
    filename = "__omnilib__/graphics/icons/blank.png",
    priority = "medium",
    width = 1,
    height = 1,
    frame_count = 1,
    shift = {0, 0}
  },
  door_animation_up ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-up.png",
    priority = "medium",
    width = 64,
    height = 32,
    frame_count = 16,
    shift = {0, -1.5}
  },
  door_animation_down ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-down.png",
    priority = "medium",
    width = 64,
    height = 32,
    frame_count = 16,
    shift = {0, -0.5}
  },
  recharging_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargoroboport-recharging.png",
    priority = "high",
    width = 74,
    height = 70,
    frame_count = 16,
    scale = 1.5,
    animation_speed = 0.5
  },
  working_sound ={
    sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.6 },
    max_sounds_per_type = 3,
    audible_distance_modifier = 0.5,
    probability = 1 / (5 * 60) -- average pause between the sound is 5 seconds
  },
  open_door_trigger_effect ={
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
    },
  },
  close_door_trigger_effect ={
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
    },
  },
}
--logistic roboport
omni.logistics.logistic_port_parts={
  charging_offsets ={
    {-3, -1}, {3, -1}, {1.5, 1}, {-1.5, 1}, {1.5, -3}, {-1.5, -3},
  },
  base ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport.png",
    width = 320,
    height = 320,
    shift = {0.5, -0.25}
  },
  base_patch ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-patch.png",
    priority = "medium",
    width = 96,
    height = 96,
    frame_count = 1,
    shift = {0, -0.25}
  },
  base_animation ={
    filename = "__omnilib__/graphics/icons/blank.png",
    priority = "medium",
    width = 1,
    height = 1,
    frame_count = 1,
    shift = {0, 0}
  },
  door_animation_up ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-up.png",
    priority = "medium",
    width = 64,
    height = 32,
    frame_count = 16,
    shift = {0, -1}
  },
  door_animation_down ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargo-roboport-door-down.png",
    priority = "medium",
    width = 64,
    height = 32,
    frame_count = 16,
    shift = {0, 0}
  },
  recharging_animation ={
    filename = "__omnimatter_logistics__/graphics/entity/cargo-roboport/cargoroboport-recharging.png",
    priority = "high",
    width = 74,
    height = 70,
    frame_count = 16,
    scale = 1.5,
    animation_speed = 0.5
  },
  working_sound ={
    sound = { filename = "__base__/sound/roboport-working.ogg", volume = 0.6 },
    max_sounds_per_type = 3,
    audible_distance_modifier = 0.5,
    probability = 1 / (5 * 60) -- average pause between the sound is 5 seconds
  },
  open_door_trigger_effect ={
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 1.2 }
    },
  },
  close_door_trigger_effect ={
    {
      type = "play-sound",
      sound = { filename = "__base__/sound/roboport-door.ogg", volume = 0.75 }
    },
  },
}
--circuit connector offsets per entity
omni.logistics.circuit_connector_definitions={
  ["roboport"]=circuit_connector_definitions.create(universal_connector_template,{
      { variation = 26, main_offset = util.by_pixel(0, 64), shadow_offset = util.by_pixel(2, 78), show_shadow = false },
    }
  ),
  ["log-zone-expander-sml"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(2, 12), show_shadow = false}
    }
  ),
  ["log-zone-expander-lge"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(8, 0), shadow_offset = util.by_pixel(10, 12), show_shadow = false}
    }
  ),
  ["relay-station-sml"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(2, 12), show_shadow = false}
    } 
  ),
  ["relay-station-lrg"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(8, 0), shadow_offset = util.by_pixel(10, 12), show_shadow = false}
    }
  ),
  ["construction-zone-expander-sml"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(0, 0), shadow_offset = util.by_pixel(2, 12), show_shadow = false}
    }
  ),
  ["construction-zone-expander-lrg"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(8, 0), shadow_offset = util.by_pixel(10, 12), show_shadow = false}
    }
  ),
  ["charging-station"] = circuit_connector_definitions.create(universal_connector_template,{
      {variation = 26, main_offset = util.by_pixel(28, 36), shadow_offset = util.by_pixel(30, 48), show_shadow = false}
    }
  ),
  ["angels-big-chest"] = circuit_connector_definitions.create(universal_connector_template,{
      { variation = 26, main_offset = util.by_pixel(16, 16), shadow_offset = util.by_pixel(18, 28), show_shadow = false },
    }
  )
}