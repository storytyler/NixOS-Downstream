{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.quickshell ];

      xdg.configFile."quickshell/dashboard/shell.qml".source = ./qml/shell.qml;
      xdg.configFile."quickshell/dashboard/SettingsPanel.qml".source = ./qml/SettingsPanel.qml;
    })
  ];
}
