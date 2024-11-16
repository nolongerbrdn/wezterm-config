local wezterm = require("wezterm")

local available_backends = { "Dx12", "Vulkan", "Gl" }
local enumarated_gpus = wezterm.gui.enumerate_gpus()

local adapter_map = {}

for _, adapter in ipairs(enumarated_gpus) do
	if not adapter_map[adapter.device_type] then
		adapter_map[adapter.device_type] = {}
	end
	adapter_map[adapter.device_type][adapter.backend] = adapter
end

local gpu_adapter = {}

function gpu_adapter.pick_best()
	local adapters_options = adapter_map.DiscreteGpu
	local preferred_backend = available_backends[1]

	if not adapters_options then
		adapters_options = adapter_map.IntergratedGpu
	end

	if not adapters_options then
		adapters_options = adapter_map.Other
		preferred_backend = "Gl"
	end

	if not adapters_options then
		adapters_options = adapter_map.Cpu
	end

	if not adapters_options then
		wezterm.log_error("No GPU adapters found. Using Default Adapter.")
		return nil
	end

	local adapter_choice = adapters_options[preferred_backend]

	if not adapter_choice then
		wezterm.log_error("Preferred backend not available. Using Default Adapter.")
		return nil
	end

	return adapter_choice
end

function gpu_adapter.pick_manual(device_type, backend)
	local adapters_options = adapter_map[device_type]

	if not adapters_options then
		wezterm.log_error("No GPU adapters found. Using Default Adapter.")
		return nil
	end

	local adapter_choice = adapters_options[backend]

	if not adapter_choice then
		wezterm.log_error("Preferred backend not available. Using Default Adapter.")
		return nil
	end

	return adapter_choice
end

return gpu_adapter
