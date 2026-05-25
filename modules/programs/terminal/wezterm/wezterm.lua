local wezterm = require 'wezterm'

local config = {}

-- Colors
config.colors = {
  foreground = '#afc4ca',
  background = '#1f1f1f',

  cursor_bg = '#8f8f8f',
  cursor_fg = '#1f1f1f',
  cursor_border = '#8f8f8f',

  selection_fg = '#c38c00',
  selection_bg = '#1f1f1f',

  ansi = {
    '#1f1f1f', -- black
    '#a05045', -- red
    '#5d7849', -- green
    '#c38c00', -- yellow
    '#3c728c', -- blue
    '#6a5a66', -- magenta
    '#4a6666', -- cyan
    '#6b6b6b', -- white
  },

  brights = {
    '#323232', -- black
    '#d06050', -- red
    '#6da050', -- green
    '#ffc42d', -- yellow
    '#5aa0c1', -- blue
    '#887280', -- magenta
    '#688880', -- cyan
    '#cfd3db', -- white
  },
}

-- Font
config.font_size = 12.0

-- Window
config.window_background_opacity = 0.2
config.window_decorations = 'NONE'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.initial_cols = 100
config.initial_rows = 30

-- Shell
config.default_prog = { 'zsh' }

-- Scrollback
config.scrollback_lines = 10000

-- Selection
config.selection_word_boundary = ' \t\n{}()[]\'\"`'

-- Disable update checks
config.check_for_updates = false

-- Keybindings
config.keys = {
  -- Ctrl+F: fzf directory navigation
  {
    key = 'F',
    mods = 'CTRL',
    action = wezterm.action.SendString(
      'cd $(fd . /mnt/work /mnt/work/dev/ /run /run/current-system ~/.local/ ~/ --max-depth 2 | fzf)\r'
    ),
  },
  -- Ctrl+T: tmux-sessionizer
  {
    key = 'T',
    mods = 'CTRL',
    action = wezterm.action.SendString 'tmux-sessionizer\r',
  },
  -- Ctrl+Y: Paste
  {
    key = 'Y',
    mods = 'CTRL',
    action = wezterm.action.Paste,
  },
  -- Alt+W: Copy
  {
    key = 'W',
    mods = 'ALT',
    action = wezterm.action.Copy,
  },
  -- Super+Shift+Return: New window
  {
    key = 'Enter',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
}

return config
