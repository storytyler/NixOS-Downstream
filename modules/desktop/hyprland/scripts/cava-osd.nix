{ pkgs, ... }:
let
  cavaPatched = (pkgs.cava.override { withSDL2 = true; }).overrideAttrs (finalAttrs: {
    patches = (finalAttrs.patches or []) ++ [ ../programs/cava-osd/alpha-framebuffer.patch ];
  });
in
pkgs.writeShellScriptBin "cava-osd" ''
  # Start cava in SDL_GLSL mode with the OSD config
  # If config doesn't exist, exit silently (module not enabled on this host)
  config="$HOME/.config/cava/cava-osd.config"
  if ! test -f "$config"; then
    exit 0
  fi
  exec ${cavaPatched}/bin/cava -p "$config"
''
