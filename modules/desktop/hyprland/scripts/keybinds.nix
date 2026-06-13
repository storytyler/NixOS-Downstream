{ pkgs, ... }:
let
  flakePath = "$HOME/NixOS/flake.nix";
in
pkgs.writeShellScriptBin "keybinds" ''
  if ${pkgs.procps}/bin/pidof rofi >/dev/null; then
    ${pkgs.procps}/bin/pkill rofi
  fi

  if ${pkgs.procps}/bin/pidof yad >/dev/null; then
    ${pkgs.procps}/bin/pkill yad
  fi

  get_nix_value() {
    ${pkgs.gawk}/bin/awk '
    /settings = {/ {inside_settings=1; next}
    inside_settings && /}/ {inside_settings=0}
    inside_settings && $0 ~ key {print gensub(/.*"([^"]+)".*/, "\\1", "g", $0)}
    ' key="$1" "${flakePath}"
  }

  _browser=$(get_nix_value "browser =")
  _terminal=$(get_nix_value "terminal =")
  _terminal_FM=$(get_nix_value "tuiFileManager =")

  ${pkgs.yad}/bin/yad \
    --center \
    --title="Hyprland Keybinds" \
    --no-buttons \
    --list \
    --width=745 \
    --height=920 \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
    "SUPER Return" "Launch terminal" "$_terminal" \
    "SUPER T" "Launch terminal" "$_terminal" \
    "SUPER E" "Launch file manager" "$_terminal_FM" \
    "SUPER C" "Launch editor" "code --disable-gpu" \
    "SUPER F" "Launch browser" "$_browser" \
    "SUPER SHIFT S" "Launch spotify" "spotify" \
    "SUPER SHIFT Y" "Launch youtube-music" "youtube-music" \
    "SUPER SHIFT P" "Launch Pokemon Infinite Fusion" "wine ~/.games/InfiniteFusion.exe" \
    "SUPER CTRL SHIFT P" "Launch Pokemon Infinite Fusion: Hoenn" "wine ~/.games/Hoenn/InfiniteFusion2.exe" \
    "SUPER B" "Launch factcheck" "launcher factcheck" \
    "SUPER ALT Tab" "Window switcher (all workspaces)" "launcher window" \
    "CTRL ALT Delete" "Open system monitor" "$_terminal -e 'btop'" \
    "SUPER A" "Launch application menu" "launcher drun" \
    "SUPER SPACE" "Launch application menu" "launcher drun" \
    "SUPER SHIFT W" "Launch wallpaper menu" "launcher wallpaper" \
    "SUPER SHIFT T" "Launch tmux sessions" "launcher tmux" \
    "SUPER G" "Game launcher" "launcher games" \
    "SUPER F8" "Toggle autoclicker (40 CPS)" "autoclicker --cps 40" \
    "SUPER F9" "Enable night mode" "hyprsunset --temperature 3500" \
    "SUPER F10" "Disable night mode" "pkill hyprsunset" \
    "SUPER CTRL C" "Colour picker (hex)" "hyprpicker --autocopy --format=hex" \
    "XF86Sleep" "Suspend system" "systemctl suspend" \
    "SUPER, Left Click" "Move window with mouse" "movewindow" \
    "SUPER, Right Click" "Resize window with mouse" "resizewindow" \
    "SUPER SHIFT →" "Resize window right" "resizeactive 30 0" \
    "SUPER SHIFT ←" "Resize window left" "resizeactive -30 0" \
    "SUPER SHIFT ↑" "Resize window up" "resizeactive 0 -30" \
    "SUPER SHIFT ↓" "Resize window down" "resizeactive 0 30" \
    "SUPER SHIFT L" "Resize window right (HJKL)" "resizeactive 30 0" \
    "SUPER SHIFT H" "Resize window left (HJKL)" "resizeactive -30 0" \
    "SUPER SHIFT K" "Resize window up (HJKL)" "resizeactive 0 -30" \
    "SUPER SHIFT J" "Resize window down (HJKL)" "resizeactive 0 30" \
    "XF86MonBrightnessDown" "Decrease brightness" "brightnessctl set 2%-" \
    "XF86MonBrightnessUp" "Increase brightness" "brightnessctl set +2%" \
    "XF86AudioLowerVolume" "Lower volume" "pamixer -d 2" \
    "XF86AudioRaiseVolume" "Increase volume" "pamixer -i 2" \
    "XF86AudioMicMute" "Mute microphone" "pamixer --default-source -t" \
    "XF86AudioMute" "Mute audio" "pamixer -t" \
    "XF86AudioPlay" "Play/Pause media" "playerctl play-pause" \
    "XF86AudioNext" "Next media track" "playerctl next" \
    "XF86AudioPrev" "Previous media track" "playerctl previous" \
    "SUPER Delete" "Exit Hyprland session" "exit" \
    "SUPER W" "Toggle floating window" "togglefloating" \
    "SUPER SHIFT G" "Toggle window group" "togglegroup" \
    "ALT Return" "Toggle fullscreen" "fullscreen" \
    "SUPER ALT L" "Lock screen" "hyprlock" \
    "SUPER Backspace" "Power menu" "wlogout -b 4" \
    "CTRL Escape" "Toggle bar" "pkill waybar/hyprpanel || bar" \
    "SUPER SHIFT N" "Open notification panel" "swaync-client -t -sw" \
    "SUPER SHIFT Q" "Open notification panel" "swaync-client -t -sw" \
    "SUPER Q" "Close active window" "killactive" \
    "ALT F4" "Force kill active window" "killactive" \
    "SUPER Z" "Launch emoji picker" "launcher emoji" \
    "SUPER ALT K" "Change keyboard layout" "keyboardswitch" \
    "SUPER U" "Rebuild system" "$_terminal -e rebuild" \
    "SUPER ALT G" "Enable game mode" "gamemode" \
    "SUPER V" "Clipboard manager" "clipmanager" \
    "SUPER M" "Online music" "rofimusic" \
    "SUPER SHIFT R" "Screen record (select area)" "screen-record a" \
    "SUPER CTRL R" "Screen record (select monitor)" "screen-record m" \
    "SUPER P" "Screenshot (select area)" "screenshot s" \
    "SUPER CTRL P" "Screenshot (frozen screen)" "screenshot sf" \
    "SUPER Print" "Screenshot (current monitor)" "screenshot m" \
    "SUPER ALT P" "Screenshot (all monitors)" "screenshot p" \
    "SUPER SHIFT CTRL ←" "Move window left" "movewindow l" \
    "SUPER SHIFT CTRL →" "Move window right" "movewindow r" \
    "SUPER SHIFT CTRL ↑" "Move window up" "movewindow u" \
    "SUPER SHIFT CTRL ↓" "Move window down" "movewindow d" \
    "SUPER SHIFT CTRL H" "Move window left (HJKL)" "movewindow l" \
    "SUPER SHIFT CTRL L" "Move window right (HJKL)" "movewindow r" \
    "SUPER SHIFT CTRL K" "Move window up (HJKL)" "movewindow u" \
    "SUPER SHIFT CTRL J" "Move window down (HJKL)" "movewindow d" \
    "SUPER CTRL ALT →" "Move window to next workspace" "workspace r+1" \
    "SUPER CTRL ALT ←" "Move window to prev workspace" "workspace r-1" \
    "SUPER CTRL S" "Move to scratchpad" "movetoworkspacesilent special" \
    "SUPER ALT S" "Move to scratchpad (no follow)" "movetoworkspacesilent special" \
    "SUPER S" "Toggle scratchpad workspace" "togglespecialworkspace" \
    "SUPER Tab" "Cycle next window" "cyclenext" \
    "SUPER Tab" "Bring active window to top" "bringactivetotop" \
    "SUPER CTRL →" "Switch to next workspace" "workspace r+1" \
    "SUPER CTRL ←" "Switch to previous workspace" "workspace r-1" \
    "SUPER CTRL ↓" "Go to first empty workspace" "workspace empty" \
    "SUPER ←" "Move focus left" "movefocus l" \
    "SUPER →" "Move focus right" "movefocus r" \
    "SUPER ↑" "Move focus up" "movefocus u" \
    "SUPER ↓" "Move focus down" "movefocus d" \
    "SUPER H" "Move focus left (HJKL)" "movefocus l" \
    "SUPER L" "Move focus right (HJKL)" "movefocus r" \
    "SUPER K" "Move focus up (HJKL)" "movefocus u" \
    "SUPER J" "Move focus down (HJKL)" "movefocus d" \
    "ALT Tab" "Move focus down" "movefocus d" \
    "SUPER Mouse Side 1" "Go to workspace 5" "workspace 5" \
    "SUPER Mouse Side 2" "Go to workspace 6" "workspace 6" \
    "SUPER SHIFT Mouse Side 1" "Move window to workspace 5" "workspace 5" \
    "SUPER SHIFT Mouse Side 2" "Move window to workspace 6" "workspace 6" \
    "SUPER Scroll" "Scroll through workspaces" "workspace e+1/e-1" \
    "SUPER 1-0" "Switch to workspace 1-10" "workspace 1-10" \
    "SUPER SHIFT 1-0" "Move to workspace 1-10" "movetoworkspace 1-10" \
    "SUPER CTRL 1-0" "Move to workspace 1-10 (no follow)" "movetoworkspace 1-10"
''
