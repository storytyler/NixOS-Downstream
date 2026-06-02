{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (_: {
      home.packages = [ pkgs.quickshell ];

      xdg.configFile."quickshell/dashboard/shell.qml".source = ./qml/shell.qml;
    })
  ];
}
