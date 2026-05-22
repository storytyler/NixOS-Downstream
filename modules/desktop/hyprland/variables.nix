{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (import ../../../hosts/${host}/variables.nix)
    bar
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
    wallpaperPicker
    ;

  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
  batterynotify = pkgs.callPackage ./scripts/batterynotify.nix { };
  clipmanager = pkgs.callPackage ./scripts/clipmanager.nix { };
  gamemode = pkgs.callPackage ./scripts/gamemode.nix { };
  keyboardswitch = pkgs.callPackage ./scripts/keyboardswitch.nix { };
  keybinds = pkgs.callPackage ./scripts/keybinds.nix { };
  rofimusic = pkgs.callPackage ./scripts/rofimusic.nix { };
  screen_record = pkgs.callPackage ./scripts/screen-record.nix { };
  screenshot = pkgs.callPackage ./scripts/screenshot.nix { };
  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { inherit defaultWallpaper; };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        xdg.configFile."hypr/variables.lua" = {
          text = ''
            bar = "${if bar == "wayle" then "wayle shell" else bar}"
            autoclicker = "${getExe autoclicker}"
            batterynotify = "${getExe batterynotify}"
            clipmanager = "${getExe clipmanager}"
            fileManager = "term --class \"tuiFileManager\" -e ${tuiFileManager}"
            gamemode = "${getExe gamemode}"
            keyboardswitch = "${getExe keyboardswitch}"
            keybinds = "${getExe keybinds}"
            rofimusic = "${getExe rofimusic}"
            screen_record = "${getExe screen_record}"
            screenshot = "${getExe screenshot}"
            wallpaper = "${getExe wallpaper}"

            mainMod = "SUPER"
            launcher = "launcher"
            term = "${getExe pkgs.${terminal}}"
            editor = "code --disable-gpu"
            browser = "${browser}"
            kbdLayout = "${kbdLayout}"
            kbdVariant = "${kbdVariant}"
            wallpaperPicker = "${wallpaperPicker}"
          '';
        };
      }
    )
  ];
}
