{
  host,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../../../hosts/${host}/variables.nix)
    clock24h
    bluetoothSupport
    batterySupport
    ;
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
            bg = "transparent";
            background-opacity = 0;
            rounding = "sm";
            border-location = "none";
            padding = 0.35;
            padding-ends = 0.5;
            end-inset = 1.0;
            module-gap = 1.0;
            button-variant = "block-prefix";
            button-rounding = "sm";
            button-label-weight = "semibold";
            button-opacity = 0.0;
            button-icon-size = 1.5;
            button-group-rounding = "md";
            button-group-padding = 1.0;
            button-group-background = "transparent";
            button-group-border-location = "bottom";
            button-group-border-width = 2;
            button-group-border-color = "blue";
            layout = [
              {
                monitor = "*";
                left = [
                  {
                    name = "left-group";
                    modules = [
                      "dashboard"
                      "hyprland-workspaces"
                      "systray"
                    ];
                  }
                ];
                center = [
                  {
                    name = "center-group";
                    modules = [
                      "clock"
                      "weather"
                    ];
                  }
                ];
                right = [
                  {
                    name = "volume-group";
                    modules = [ "volume" ];
                  }
                  {
                    name = "right-group";
                    modules = [
                      "hyprsunset"
                      "idle-inhibit"
                      "notifications"
                    ];
                  }
                ]
                ++ lib.optionals (batterySupport == true) [ "battery" ];
              }
            ];
          };

          # ── Module Settings ──────────────────────────────────────
          modules = {
            # Dashboard (profile dropdown with power menu)
            dashboard = {
              icon-override = "";
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
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
              active-indicator = "underline";
              active-color = "blue";
              occupied-color = "fg-muted";
              empty-color = "hover";
              container-bg-color = "transparent";
              icon-gap = 0.0;
              workspace-padding = 0.0;
            };

            # Window title
            window-title = {
              icon-show = true;
              label-show = true;
              label-max-length = 50;
            };

            # Volume (icon only)
            volume = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
              right-click = "pavucontrol";
              scroll-up = "wayle audio output-volume +5";
              scroll-down = "wayle audio output-volume -5";
            };

            # Network (icon only, no label)
            network = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
            };

            # Bluetooth (icon only, no label)
            bluetooth = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
            };

            # Battery (icon only, no label)
            battery = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
            };

            # System tray
            systray = {
              button-bg-color = "transparent";
            };

            # Idle inhibit (hypridle toggle, icon only)
            idle-inhibit = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
              icon-active = "tb-coffee-symbolic";
              icon-inactive = "tb-coffee-off-symbolic";
              startup-duration = 60;
            };

            # Hyprsunset (night light toggle)
            hyprsunset = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
            };

            # Clock (respects clock24h from host variables)
            clock = {
              format = if clock24h == true then "%a %d %b %R" else "%a %d %b %I:%M %p";
              icon-show = false;
              label-show = true;
              label-color = "blue";
              button-bg-color = "transparent";
            };

            # Weather (imperial, right of clock)
            weather = {
              units = "imperial";
              location = "San Francisco";
              format = "{{ temp }}{{ temp_unit }} {{ condition }}";
              icon-color = "blue";
              icon-bg-color = "transparent";
              label-color = "blue";
              button-bg-color = "transparent";
            };

            # Notifications (built-in, replaces swaync, icon only)
            notifications = {
              icon-color = "blue";
              icon-bg-color = "transparent";
              button-bg-color = "transparent";
              border-show = false;
              label-show = false;
              popup-duration = 3500;
              popup-position = "top-right";
              popup-max-visible = 3;
              middle-click = "wayle notify dismiss-all";
            };

            # Media (title only, truncated to 25 chars)
            media = {
              format = "{{ title }}";
              label-max-length = 25;
            };
          };

          # ── Overlays ─────────────────────────────────────────────
          overlays = {
            osd = {
              position = "bottom";
              duration = 1000;
              margin = 10.0;
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
