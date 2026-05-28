{ pkgs, ... }:
let
  cavaConfig = pkgs.writeText "cava-config" ''
    [general]
    framerate = 60
    bars = 0
    bar_width = 1
    bar_height = 9
    autosens = 1
    sensitivity = 100

    [color]
    gradient = 0
    foreground = '#3c3c3c'

    [output]
    method = noncurses
    orientation = horizontal
    channels = stereo
    reverse = 0
  '';

  cava-osd = pkgs.writeShellScriptBin "cava-osd" ''
    exec ${pkgs.kitty}/bin/kitty +kitten panel \
      --edge=background \
      --focus-policy=not-allowed \
      --margin-top=960 \
      --margin-bottom=3 \
      --margin-left=2 \
      --margin-right=2 \
      -o background_opacity=0.0 \
      -o background='#000000' \
      -o font_size=1 \
      -o 'modify_font cell_width 50%' \
      -o 'modify_font cell_height 50%' \
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
