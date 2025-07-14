local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- フォント設定
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 14.0

-- カラースキーム
config.color_scheme = 'Catppuccin Mocha'

-- ウィンドウ設定
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'

-- タブ設定
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false

-- キーバインド
config.keys = {
    {
        key = 'w',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key = 't',
        mods = 'CMD',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'D',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
}

-- マウス設定
config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CMD',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}

-- 起動時設定
config.default_prog = { '/bin/zsh', '-l' }

return config

