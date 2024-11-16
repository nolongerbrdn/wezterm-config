local wezterm = require("wezterm")

local font_family = "Iosevka Nerd Font"
local font_size = 18

local cell_width = 1

return {
	font = wezterm.font({
		family = font_family,
		weight = "Medium",
	}),
	font_size = font_size,
	cell_width = cell_width,

	freetype_load_target = "Normal",
	freetype_render_target = "Normal",
}
