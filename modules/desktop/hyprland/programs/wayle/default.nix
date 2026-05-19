{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) clock24h bluetoothSupport batterySupport;
in
{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    python314Packages.gpustat
    brightnessctl
    wf-recorder
  ];

  # Wayle reads avatar from ~/.face
  environment.etc."wayle-face".source = ./profile-picture.jpg;

  home-manager.sharedModules = [
    (_: {
      services.wayle = {
        enable = true;
        settings = {
          # ── Tokyo Night Palette ──────────────────────────────────────
          styling = {
            theme-provider = "wayle";
            rounding = "sm";
            palette = {
              bg = "#1a1b26";
              surface = "#16161e";
              elevated = "#292e42";
              fg = "#c0caf5";
              fg-muted = "#565f89";
              primary = "#7aa2f7";
              red = "#f7768e";
              yellow = "#e0af68";
              green = "#9ece6a";
              blue = "#7aa2f7";
            };
          };

          # ── Bar Chrome ────────────────────────────────────────────
          bar = {
            location = "top";
            background-opacity = 100;
            rounding = "sm";
            border-location = "none";
            padding = 0.35;
            padding-ends = 0.5;
            module-gap = 0.5;
            button-variant = "block-prefix";
            button-rounding = "sm";
            button-label-weight = "semibold";
            layout = [
              {
                monitor = "*";
                left = [
                  "dashboard"
                  "hyprland-workspaces"
                  "cava"
                ];
                center = [
                  "window-title"
                ];
                right =
                  [ "volume" "network" "systray" "idle-inhibit" "hyprsunset" "clock" "notifications" ]
                  ++ lib.optionals (bluetoothSupport == true) [ "bluetooth" ]
                  ++ lib.optionals (batterySupport == true) [ "battery" ];
              }
            ];
          };

          # ── Module Settings ──────────────────────────────────────
          modules = {
            # Dashboard (profile dropdown with power menu)
            dashboard = {
              icon-override = "";
            };

            # Workspaces (pills/bubbles, no numbers — matches HyprPanel style)
            hyprland-workspaces = {
              min-workspace-count = 10;
              monitor-specific = false;
              show-special = false;
              display-mode = "none";
              app-icons-show = true;
              app-icons-empty = "tbf-circle-symbolic";
              workspace-ignore = [ "-99" ];
              active-indicator = "background";
              active-color = "primary";
              occupied-color = "fg-muted";
              empty-color = "fg-muted";
              icon-gap = 0.0;
              workspace-padding = 0.0;
            };

            # Cava (audio visualizer, click = play/pause)
            cava = {
              bars = 20;
              framerate = 60;
              style = "bars";
              direction = "normal";
              left-click = "${pkgs.playerctl}/bin/playerctl play-pause";
            };

            # Window title
            window-title = {
              icon-show = true;
              label-show = true;
              label-max-length = 50;
            };

            # Volume
            volume = {
              right-click = "pavucontrol";
            };

            # Network (show label + wifi info)
            network = {
              label-show = true;
            };

            # System tray (defaults are fine)

            # Idle inhibit (hypridle toggle)
            idle-inhibit = {
              format = "{{ state }}";
              icon-active = "tb-coffee-symbolic";
              icon-inactive = "tb-coffee-off-symbolic";
              label-show = true;
              startup-duration = 60;
            };

            # Clock (respects clock24h from host variables)
            clock = {
              format = if clock24h == true then "%a %d %b %R" else "%a %d %b %I:%M %p";
              icon-show = false;
              label-show = true;
            };

            # Notifications (built-in, replaces swaync)
            notifications = {
              popup-duration = 3500;
              popup-position = "top-right";
              popup-max-visible = 5;
            };

            # Media (title only, truncated to 25 chars)
            media = {
              format = "{{ title }}";
              label-max-length = 25;
            };
          };
        };
      };

      # Symlink profile picture to ~/.face for Wayle dashboard avatar
      xdg.configFile."wayle-avatar" = {
        source = ./profile-picture.jpg;
        target = "../.face";
      };
    })
  ];
}
