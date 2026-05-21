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

  # Wrapper script that launches kitty panel at the background layer
  cava-osd = pkgs.writeShellScriptBin "cava-osd" ''
    exec ${pkgs.kitty}/bin/kitty +kitten panel \
      --edge=background \
      --focus-policy=not-allowed \
      -o background_opacity=0.0 \
      -o background='#000000' \
      -o font_size=1 \
      --detach \
      -- ${pkgs.cava}/bin/cava -p ${cavaConfig}
  '';
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ cava-osd ];
    })
  ];
}
