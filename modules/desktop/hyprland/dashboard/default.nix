{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.quickshell ];

      xdg.configFile."quickshell/dashboard/shell.qml".source = ./qml/shell.qml;
      xdg.configFile."quickshell/dashboard/SettingsPanel.qml".source = ./qml/SettingsPanel.qml;
      xdg.configFile."quickshell/dashboard/ArcGauge.qml".source = ./qml/ArcGauge.qml;
      xdg.configFile."quickshell/dashboard/RadialGauge.qml".source = ./qml/RadialGauge.qml;
      xdg.configFile."quickshell/dashboard/WaveFill.qml".source = ./qml/WaveFill.qml;
      xdg.configFile."quickshell/dashboard/HexFrame.qml".source = ./qml/HexFrame.qml;
      xdg.configFile."quickshell/dashboard/HudPoC.qml".source = ./qml/HudPoC.qml;
    })
  ];
}
