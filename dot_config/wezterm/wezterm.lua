local wezterm = require 'wezterm'

return {
  -- 基本設定
  font = wezterm.font('JetBrains Mono', { weight = 'Medium' }),
  font_size = 14.0,
  
  -- テーマ設定
  color_scheme = 'Catppuccin Mocha',
  
  -- ウィンドウ設定
  window_background_opacity = 0.95,
  window_decorations = 'RESIZE',
  
  -- タブ設定
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  
  -- キーバインド
  keys = {
    { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentTab{ confirm = true } },
    { key = 'd', mods = 'CMD', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
    { key = 'd', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
  },
  
  -- SSH設定
  ssh_domains = {},
  
  -- 起動時の設定
  default_prog = { 'zsh', '-l' },
}
