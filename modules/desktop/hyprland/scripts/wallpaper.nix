{ pkgs, defaultWallpaper, ... }:
pkgs.writeShellScriptBin "wallpaper" ''

  # Restore
  awww restore &> /dev/null

  # If there is no wallpaper then set the default
  if ! awww query | grep -q "image:" &> /dev/null; then
    awww img "${../../../themes/wallpapers/${defaultWallpaper}}"
  fi
''
