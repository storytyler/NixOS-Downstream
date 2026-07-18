{
  host,
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) optional;
  hostVars = import ../../../hosts/${host}/variables.nix;
  inherit (hostVars) bar;
  wallpaperPicker = hostVars.wallpaperPicker or "rofi";
in
{
  imports = [
    ../../themes/phocus
    ./variables.nix
    ./programs/${bar}
    ./programs/cava-osd
    ./programs/wlogout
    ./programs/rofi
    ./programs/hypridle
    ./programs/hyprlock
    ./dashboard
  ]
  ++ optional (bar != "hyprpanel" && bar != "wayle" && bar != "caelestia-shell") ./programs/swaync
  ++ optional (wallpaperPicker == "skwd-wall") ./programs/skwd-wall;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  home-manager.sharedModules = [
    (_: {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          config.programs.hyprland.portalPackage
        ];
        xdgOpenUsePortal = true;
        configPackages = [ config.programs.hyprland.package ];
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
          "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Print" = "gtk";
        };
      };

      home.packages = with pkgs; [
        hyprpicker
        hyprsunset
        cliphist
        wf-recorder
        grimblast
        slurp
        swappy
        libnotify
        brightnessctl
        networkmanagerapplet
        pamixer
        pavucontrol
        playerctl
        wtype
        wl-clipboard
        xdotool
        yad
      ] ++ optional (wallpaperPicker == "skwd-wall") inputs.skwd-wall.packages.${pkgs.stdenv.hostPlatform.system}.default
        ++ optional (wallpaperPicker != "skwd-wall") pkgs.awww;

      services.awww.enable = wallpaperPicker != "skwd-wall";

      xdg.configFile = {
        "hypr/hyprland.lua".source = ./lua/hyprland.lua;
        "hypr/monitors.lua".source = ./lua/monitors.lua;
        "hypr/settings.lua".source = ./lua/settings.lua;
        "hypr/animations.lua".source = ./lua/animations.lua;
        "hypr/binds.lua".source = ./lua/binds.lua;
        "hypr/rules.lua".source = ./lua/rules.lua;

        "hypr/icons" = {
          source = ./icons;
          recursive = true;
        };
      };
    })
  ];
}
