local wezterm = require("wezterm")

-- Cache commonly used functions into local variables
local enumerate_gpus = wezterm.gui.enumerate_gpus
local log_error = wezterm.log_error

-- GPU backends to check for
local available_backends = { "Dx12", "Vulkan", "Gl" }

-- Cache the GPU enumeration once
local enumerated_gpus = enumerate_gpus()

-- Create an adapter map for faster access
local adapter_map = {}

for _, adapter in ipairs(enumerated_gpus) do
    local device_type = adapter.device_type
    local backend = adapter.backend

    -- Initialize the map only if it doesn't exist
    adapter_map[device_type] = adapter_map[device_type] or {}
    adapter_map[device_type][backend] = adapter
end

-- GPU adapter functions
local gpu_adapter = {}

-- Pick the best adapter, optimized for speed
function gpu_adapter.pick_best()
    -- Check for available discrete GPU
    local adapters_options = adapter_map.DiscreteGpu
    if not adapters_options then
        -- Fall back to integrated GPU
        adapters_options = adapter_map.IntegratedGpu
    end

    -- If no discrete or integrated GPU, fall back to 'Other'
    if not adapters_options then
        adapters_options = adapter_map.Other
    end

    -- If no 'Other' GPU, fall back to CPU
    if not adapters_options then
        adapters_options = adapter_map.Cpu
    end

    -- If no adapters found at all, log error and return nil
    if not adapters_options then
        log_error("No GPU adapters found. Using Default Adapter.")
        return nil
    end

    -- Try to pick the best available backend from the prioritized list
    for _, backend in ipairs(available_backends) do
        local adapter_choice = adapters_options[backend]
        if adapter_choice then
            return adapter_choice
        end
    end

    -- If no preferred backend is available, fallback to the first available backend
    for _, backend in pairs(adapters_options) do
        return backend
    end

    -- If no backend available, return nil
    log_error("No GPU adapter available with the preferred backends.")
    return nil
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
