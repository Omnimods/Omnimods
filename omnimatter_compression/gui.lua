mod_gui = require("mod-gui")
function create_gui(player)
  mod_gui.get_button_flow(player).add
  {
    type = "sprite-button",
    name = "My_mod_button",
    sprite = "item/my-mod-item",
    style = mod_gui.button_style
  }
  mod_gui.get_frame_flow(player).add
  {
    type = "frame",
    name = "My_mod_frame",
    caption = "My mod frame",
    style = mod_gui.frame_style
  }
end