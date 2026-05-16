{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      # Stub: HyprPanel bar support
      # Flesh out when switching to hyprpanel:
      #   - Add hyprpanel flake input (github:Jas-SinghFSU/HyprPanel)
      #   - Configure programs.hyprpanel or deploy config via xdg.configFile
      #   - swaync is automatically disabled (bar != "hyprpanel" → no swaync import)
    })
  ];
}
