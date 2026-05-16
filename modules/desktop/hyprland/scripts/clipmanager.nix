{ pkgs, ... }:
pkgs.writeShellScriptBin "clipmanager" ''
  # Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

  # Actions:
  # CTRL Del to delete an entry
  # ALT Del to wipe clipboard contents

  rofi_theme="''${XDG_CONFIG_HOME:-$HOME/.config}/rofi/launchers/type-1/style-6.rasi"
  r_override="entry{placeholder:'Search Clipboard...';}listview{lines:9;}"

  while true; do
    result=$(
      ${pkgs.rofi-wayland}/bin/rofi -dmenu -i \
        -kb-custom-1 "Control-Delete" \
        -kb-custom-2 "Alt-Delete" \
        -theme-str "$r_override" \
        -theme "$rofi_theme" < <(${pkgs.cliphist}/bin/cliphist list)
    )

    case "$?" in
    1)
      exit
      ;;
    0)
      case "$result" in
      "")
        continue
        ;;
      *)
        ${pkgs.cliphist}/bin/cliphist decode <<<"$result" | ${pkgs.wl-clipboard}/bin/wl-copy
        exit
        ;;
      esac
      ;;
    10)
      ${pkgs.cliphist}/bin/cliphist delete <<<"$result"
      ;;
    11)
      ${pkgs.cliphist}/bin/cliphist wipe
      ;;
    esac
  done
''
