{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe;
  inherit (import ../../../hosts/${host}/variables.nix)
    browser
    terminal
    tuiFileManager
    kbdLayout
    kbdVariant
    defaultWallpaper
    ;

  autoclicker = pkgs.callPackage ./scripts/autoclicker.nix { };
  wallpaper = pkgs.callPackage ./scripts/wallpaper.nix { inherit defaultWallpaper; };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        xdg.configFile."hypr/variables.lua" = {
          text = ''
            autoclicker = "${getExe autoclicker}"
            batterynotify = "${./scripts/batterynotify.sh}"
            clipmanager = "${./scripts/ClipManager.sh}"
            dontkillsteam = "${./scripts/dontkillsteam.sh}"
            fileManager = "term --class \"tuiFileManager\" -e ${tuiFileManager}"
            gamemode = "${./scripts/gamemode.sh}"
            keyboardswitch = "${./scripts/keyboardswitch.sh}"
            keybinds = "${./scripts/keybinds.sh}"
            rofimusic = "${./scripts/rofimusic.sh}"
            screen_record = "${./scripts/screen-record.sh}"
            screenshot = "${./scripts/screenshot.sh}"
            wallpaper = "${getExe wallpaper}"

            mainMod = "SUPER"
            launcher = "launcher"
            term = "${getExe pkgs.${terminal}}"
            editor = "code --disable-gpu"
            browser = "${browser}"
            kbdLayout = "${kbdLayout}"
            kbdVariant = "${kbdVariant}"
          '';
        };
      }
    )
  ];
}
