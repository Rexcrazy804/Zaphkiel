local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local cat_mocha = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
cat_mocha.background = '#181818'

config.window_background_opacity = 0.79
config.color_schemes = {
  ['my_cat'] = cat_mocha
}
config.color_scheme = 'my_cat'
config.bold_brightens_ansi_colors = "BrightOnly"
config.font = wezterm.font('CaskaydiaMono Nerd font', {weight = 'Regular'})
config.enable_tab_bar = false
config.font_size = 13
config.window_padding = { left = '5pt', right = '1pt', top = '5pt', bottom = '2pt'}

return config
