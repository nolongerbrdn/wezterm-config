local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
}

return {
	keys = keys,
}
