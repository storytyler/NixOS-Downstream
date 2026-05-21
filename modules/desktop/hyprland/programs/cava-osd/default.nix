{ pkgs, ... }:
let
  # Dedicated cava config for the OSD background layer
  cavaConfig = pkgs.writeText "cava-config" ''
    [general]
    framerate = 60
    bars = 0
    autosens = 1
    sensitivity = 100

    [color]
    gradient = 0
    foreground = '#6c6c6c'

    [output]
    method = noncurses
    orientation = horizontal
    channels = stereo
    reverse = 0
  '';

  # Wrapper script that launches alacritty in OSD mode
  cava-osd = pkgs.writeShellScriptBin "cava-osd" ''
    exec ${pkgs.alacritty}/bin/alacritty \
      --class cava-osd,cava-osd \
      -o window.decorations=none \
      -o window.opacity=0.0 \
      -o window.startup_mode=fullscreen \
      -o window.padding.x=0 \
      -o window.padding.y=0 \
      -o font.size=1 \
      -o colors.primary.background='#000000' \
      -e ${pkgs.cava}/bin/cava -c ${cavaConfig}
  '';
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ cava-osd ];
    })
  ];
}
