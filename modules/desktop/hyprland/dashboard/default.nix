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
      xdg.configFile."quickshell/dashboard/GlowSparkline.qml".source = ./qml/GlowSparkline.qml;
      xdg.configFile."quickshell/dashboard/DialGauge.qml".source = ./qml/DialGauge.qml;
      xdg.configFile."quickshell/dashboard/services/CpuData.qml".source = ./qml/services/CpuData.qml;
      xdg.configFile."quickshell/dashboard/services/MemData.qml".source = ./qml/services/MemData.qml;
      xdg.configFile."quickshell/dashboard/services/GpuData.qml".source = ./qml/services/GpuData.qml;
      xdg.configFile."quickshell/dashboard/services/NetData.qml".source = ./qml/services/NetData.qml;
      xdg.configFile."quickshell/dashboard/services/DiskData.qml".source = ./qml/services/DiskData.qml;
      xdg.configFile."quickshell/dashboard/services/SysInfo.qml".source = ./qml/services/SysInfo.qml;
      xdg.configFile."quickshell/dashboard/services/SignalData.qml".source = ./qml/services/SignalData.qml;
      xdg.configFile."quickshell/dashboard/services/WeatherData.qml".source = ./qml/services/WeatherData.qml;
      xdg.configFile."quickshell/dashboard/icons/weather".source = ./qml/icons/weather;
    })
  ];
}
