local gpu_adapter = require("utils.gpu_adapter")

return {
	max_fps = 120,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	webgpu_preferred_adapter = gpu_adapter.pick_best(),

	animation_fps = 120,
	cursor_blink_ease_in = "EaseOut",
	cursor_blink_ease_out = "EaseOut",
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 650,

	color_scheme = "tokyonight_night",

	-- Tab bar
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,

	-- Window
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	window_decorations = "None | RESIZE",
	window_background_opacity = 1,

	initial_cols = 80,
}
