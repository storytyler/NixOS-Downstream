local wezterm = require 'wezterm'

local config = {}

-- Colors
config.colors = {
  foreground = '#cfd3db',
  background = '#1f1f1f',

  cursor_bg = '#6acfff',
  cursor_fg = 'none',
  cursor_border = '#6acfff',

  selection_fg = '#c38c00',
  selection_bg = '#010101',

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

  tab_bar = {
    active_tab = {
      bg_color = 'none',
      fg_color = '#6acfff',
      underline = 'Single',
    },

    inactive_tab = {
      bg_color = 'none',
      fg_color = '#6b6b6b',
    },

    inactive_tab_hover = {
      bg_color = 'none',
      fg_color = '#74e91c',
    },

    new_tab = {
      bg_color = 'none',
      fg_color = '#6da050',
    },

    new_tab_hover = {
      bg_color = 'none',
      fg_color = '#74e91c',
    },
    inactive_tab_edge = '#6b6b6b',
    inactive_tab_edge_hover = '#74e91c',
  },
}
config.underline_position = "-2px"
config.underline_thickness = "2px"


-- Window
config.window_background_opacity = 0.0
config.text_background_opacity = 0.8
config.window_close_confirmation = 'NeverPrompt'
config.show_tab_index_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.window_decorations = 'NONE'
config.default_cursor_style = 'BlinkingUnderline'
config.enable_scroll_bar = false
config.window_frame = {
  inactive_titlebar_bg = 'none',
  active_titlebar_bg = 'none',
}
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
    action = wezterm.action.PasteFrom 'Clipboard',
  },
  -- Alt+W: Copy
  {
    key = 'W',
    mods = 'ALT',
    action = wezterm.action.CopyTo 'Clipboard',
  },
  -- Super+Shift+Return: New window
  {
    key = 'Enter',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SpawnWindow,
  },
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  title = wezterm.truncate_right(title, max_width - 2)

  if tab.is_active then
    return {
      { Attribute = { Underline = 'Single' } },
      { Text = ' ' .. title .. ' ' },
    }
  end
  return ' ' .. title .. ' '
end)

return config
