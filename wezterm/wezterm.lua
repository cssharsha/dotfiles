local wezterm = require 'wezterm'
local config = {}

-- It's good practice to start with an empty config table if you're
-- not overriding a default one that might already be there.
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Set all window padding to 0
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

return config
