{ host, pkgs, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.waybar = {
        enable = true;
        systemd = {
          enable = false;
          targets = "graphical-session.target";
        };
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            mode = "dock";
            height = 28;
            exclusive = true;
            passthrough = false;
            gtk-layer-shell = true;
            ipc = true;
            fixed-center = true;
            margin-top = 6;
            margin-left = 6;
            margin-right = 6;
            margin-bottom = 0;

            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [
              "pulseaudio"
              "network"
              "tray"
              "battery"
            ];

            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              active-only = false;
              on-click = "activate";
              persistent-workspaces = {
                "*" = [ 1 2 3 4 5 6 7 8 9 10 ];
              };
            };

            "clock" = {
              format = if clock24h == true then "{:%H:%M}" else "{:%I:%M %p}";
              tooltip-format = "{:%a %d %b %Y}";
              calendar = { mode = "month"; };
            };

            "pulseaudio" = {
              format = "{icon} {volume}%";
              format-muted = "";
              on-click = "pavucontrol -t 3";
              format-icons = {
                default = [ "" "" "" ];
              };
            };

            "network" = {
              format-wifi = "󰤨";
              format-ethernet = "󱘖";
              format-disconnected = "󰤮";
            };

            "tray" = {
              icon-size = 12;
              spacing = 5;
            };

            "battery" = {
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-icons = [
                "󰂎" "󰁺" "󰁻" "󰁼" "󰁽"
                "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"
              ];
            };
          };
        };
        style = ''
          * {
            font-family: "monospace";
            font-size: 13px;
            margin: 0px;
            padding: 0px;
          }

          window#waybar {
            background: transparent;
            border-radius: 8px;
          }

          .modules-left, .modules-center, .modules-right {
            background: rgba(26, 21, 19, 0.9);
            border-radius: 8px;
            padding: 0 8px;
          }

          #workspaces button {
            padding: 0 4px;
            color: #4a3a35;
            border-radius: 9px;
          }
          #workspaces button.active {
            color: #d9a066;
          }
          #workspaces button.urgent {
            color: #D1495B;
          }
          #clock { color: #E6B566; }
          #pulseaudio { color: #C67E4F; }
          #network { color: #E07A5F; }
          #battery { color: #A3A36F; }
        '';
      };
    })
  ];
}
