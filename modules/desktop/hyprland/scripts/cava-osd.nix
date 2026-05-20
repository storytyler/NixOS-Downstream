{ pkgs, ... }:
let
  cavaWithSDL = pkgs.cava.override { withSDL2 = true; };
in
pkgs.writeShellScriptBin "cava-osd" ''
  # Start cava in SDL_GLSL mode with the OSD config
  # If config doesn't exist, exit silently (module not enabled on this host)
  config="$HOME/.config/cava/cava-osd.config"
  if ! test -f "$config"; then
    exit 0
  fi
  exec ${cavaWithSDL}/bin/cava -p "$config"
''
