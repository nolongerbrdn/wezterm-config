local wezterm = require('wezterm')

local function append(lst, items)
	for k, v in pairs(items) do
		if lst[k] ~= nil then
			wezterm.log_warn(
				'Duplicate config option detected: ',
				{  old = lst[k], new = items[k] }
			)
			goto continue
		end
		lst[k] = v
	    ::continue::
	end
	return lst
end

local config = {}

for _, mod in ipairs({
  'config.appearance',
  'config.general',
  'config.launch',
  'config.bindings',
  'config.fonts'
}) do
	append(config, require(mod))
end

return config
