{ pkgs, defaultWallpaper, ... }:
let
  awww = "${pkgs.awww}/bin/awww";
  awww-daemon = "${pkgs.awww}/bin/awww-daemon";
in
pkgs.writeShellScriptBin "wallpaper" ''
  # Start the daemon if not running
  if ! pgrep -x awww-daemon &> /dev/null; then
    ${awww-daemon} &
    sleep 0.5
  fi

  # Restore cached wallpaper
  ${awww} restore &> /dev/null

  # If there is no wallpaper then set the default
  if ! ${awww} query | grep -q "image:" &> /dev/null; then
    ${awww} img "${../../../themes/wallpapers/${defaultWallpaper}}"
  fi
''
