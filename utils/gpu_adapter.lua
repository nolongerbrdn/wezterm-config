local wezterm = require("wezterm")

-- Cache commonly used functions into local variables
local enumerate_gpus = wezterm.gui.enumerate_gpus
local log_error = wezterm.log_error

-- GPU backends to check for
local available_backends = { "Vulkan", "Dx12", "Gl" }

-- Cache the GPU enumeration to avoid recalculating it multiple times
local enumarated_gpus = enumerate_gpus()

-- Create an adapter map for faster access
local adapter_map = {}

for _, adapter in ipairs(enumarated_gpus) do
    -- Avoid nested table lookups
    local device_type = adapter.device_type
    local backend = adapter.backend

    if not adapter_map[device_type] then
        adapter_map[device_type] = {}
    end
    adapter_map[device_type][backend] = adapter
end

log_error(adapter_map)
log_error(enumarated_gpus)

-- GPU adapter functions
local gpu_adapter = {}

-- Pick the best adapter, optimized for speed
function gpu_adapter.pick_best()
    local adapters_options = adapter_map.DiscreteGpu
    local preferred_backend = available_backends[1]

    -- Fall back to integrated GPU if no discrete GPUs are available
    if not adapters_options then
        adapters_options = adapter_map.IntergratedGpu
    end

    -- Fall back to 'Other' GPU if no integrated GPU is available
    if not adapters_options then
        adapters_options = adapter_map.Other
        preferred_backend = "Gl"  -- Default to OpenGL
    end

    -- Fallback to CPU if no other GPU is available
    if not adapters_options then
        adapters_options = adapter_map.Cpu
    end

    -- If no adapters are found, log an error and return nil
    if not adapters_options then
        log_error("No GPU adapters found. Using Default Adapter.")
        return nil
    end

    -- Try to pick the preferred backend
    local adapter_choice = adapters_options[preferred_backend]

    if not adapter_choice then
        log_error("Preferred backend not available. Using Default Adapter.")
        return nil
    end

    return adapter_choice
end

-- Manual adapter selection
function gpu_adapter.pick_manual(device_type, backend)
    local adapters_options = adapter_map[device_type]

    -- If no adapters found for the device type, log an error and return nil
    if not adapters_options then
        log_error("No GPU adapters found. Using Default Adapter.")
        return nil
    end

    local adapter_choice = adapters_options[backend]

    if not adapter_choice then
        log_error("Preferred backend not available. Using Default Adapter.")
        return nil
    end

    return adapter_choice
end

return gpu_adapter
