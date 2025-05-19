local wezterm = require 'wezterm'
local config = {}

-- Set default font
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12

-- Set color scheme
config.color_scheme = 'Dracula'

-- Window appearance
config.window_background_opacity = 0.95
config.enable_tab_bar = true

-- Default shell (PowerShell, cmd, or WSL)
--config.default_prog = { 'pwsh.exe' } -- PowerShell 7
-- For WSL: 
config.default_prog = { 'wsl.exe', '--distribution', 'Ubuntu-24.04' }
config.default_cwd='/home/ash'
return config




