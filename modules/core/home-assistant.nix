{
  pkgs,
  lib,
  config,
  ...
}:

{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "default_config" # Base components
      "systemmonitor" # Local system metrics (CPU, RAM, disk, etc.)
      "wake_on_lan" # Wake on LAN (available, configure later)
      "webostv" # LG webOS TV (local)
      "met" # Weather - auto-configures from lat/long
      "radio_browser"
      "shopping_list"
      "isal" # Fast compression
      "command_line" # For GPU sensors via nvidia-smi
    ];

    customLovelaceModules =
      with pkgs.home-assistant-custom-lovelace-modules;
      [
        # === EXISTING ===
        clock-weather-card # Weather display with animated icons
        card-mod # CSS injection — glassmorphism, borderless, state-based styling
        mushroom # Clean entity cards for simple readouts
        apexcharts-card # Time-series graphs, radial gauges, color thresholds, history
        bubble-card # Popups, navigation chips, buttons

        # === WALL DISPLAY ADDITIONS ===
        kiosk-mode # Hide header/sidebar for fullscreen wall display
        button-card # Ultra-customizable buttons/gauges with templated CSS
        mini-graph-card # Lightweight sparklines and inline graphs
      ]
      ++ [ pkgs.weather-forecast-extended ]; # Custom package — single card with current + hourly + daily

    config = {
      homeassistant = {
        name = "Home";
        time_zone = config.time.timeZone;
        latitude = 42.057856;
        longitude = -91.574895;
        elevation = 265; # Approximate elevation for Cedar Rapids, IA area
      };

      # Wake on LAN - add MAC addresses later via UI or here
      wake_on_lan = { };

      http = {
        server_host = "0.0.0.0";
        server_port = 8234;
      };

      # NOTE: met weather auto-configures from homeassistant lat/long.
      # Removed broken YAML weather block — HA 2026+ requires config flow for weather.
      # weather.forecast_home entity is created automatically by the met integration.

      # GPU Command Sensors via nvidia-smi
      # Modern HA format: list of { sensor = { ... }; } entries (not { sensors = [ ... ]; })
      # Entity IDs are auto-generated from name: "GPU Power" → sensor.gpu_power
      command_line = [
        {
          sensor = {
            name = "GPU Power";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits";
            unit_of_measurement = "W";
            scan_interval = 30;
          };
        }
        {
          sensor = {
            name = "GPU Temperature";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
            unit_of_measurement = "°C";
            scan_interval = 30;
          };
        }
        {
          sensor = {
            name = "GPU Utilization";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
            unit_of_measurement = "%";
            scan_interval = 30;
          };
        }
        {
          sensor = {
            name = "GPU Memory Used";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits";
            unit_of_measurement = "MB";
            scan_interval = 30;
          };
        }
        {
          sensor = {
            name = "GPU Memory Total";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits";
            unit_of_measurement = "MB";
            scan_interval = 30;
          };
        }
        {
          sensor = {
            name = "GPU Clock";
            command = "/run/current-system/sw/bin/nvidia-smi --query-gpu=clocks.sm --format=csv,noheader,nounits";
            unit_of_measurement = "MHz";
            scan_interval = 60;
          };
        }
      ];
    };

    lovelaceConfig = {
      title = "System Monitor";
      theme = "mushroom";
      background = "#0f0f0f";
      views = [
        {
          type = "panel";
          title = "System Overview";
          path = "overview";
          cards = [
            {
              type = "vertical-stack";
              cards = [
                # === WEATHER — 3-card split: current | hourly | daily (seamless) ===
                {
                  type = "horizontal-stack";
                  cards = [
                    {
                      type = "custom:clock-weather-card";
                      entity = "weather.forecast_home";
                      hide_forecast_section = true;
                      card_mod = {
                        style = ''
                          ha-card {
                            border: none !important;
                            background-color: transparent !important;
                            border-radius: 0 !important;
                            margin: 0 !important;
                          }
                        '';
                      };
                    }
                    {
                      type = "custom:clock-weather-card";
                      entity = "weather.forecast_home";
                      hourly_forecast = true;
                      hide_today_section = true;
                      hide_clock = true;
                      hide_date = true;
                      forecast_rows = 6;
                      card_mod = {
                        style = ''
                          ha-card {
                            border: none !important;
                            background-color: transparent !important;
                            border-radius: 0 !important;
                            margin: 0 !important;
                          }
                        '';
                      };
                    }
                    {
                      type = "custom:clock-weather-card";
                      entity = "weather.forecast_home";
                      hourly_forecast = false;
                      hide_today_section = true;
                      forecast_rows = 7;
                      card_mod = {
                        style = ''
                          ha-card {
                            border: none !important;
                            background-color: transparent !important;
                            border-radius: 0 !important;
                            margin: 0 !important;
                          }
                        '';
                      };
                    }
                  ];
                }

                # === SYSTEM METRICS ===
                {
                  type = "custom:apexcharts-card";
                  chart_type = "radialBar";
                  header = {
                    show = false;
                  };
                  apex_config = {
                    chart = {
                      height = 200;
                    };
                    plotOptions = {
                      radialBar = {
                        hollow = { size = "50%"; };
                        dataLabels = {
                          name = { show = true; fontSize = "14px"; };
                          value = { show = true; fontSize = "18px"; };
                          total = { show = false; };
                        };
                      };
                    };
                    stroke = { lineCap = "round"; };
                    colors = [ "#4caf50" "#2196f3" ];
                    legend = { show = true; position = "bottom"; floating = false; };
                  };
                  series = [
                    {
                      entity = "sensor.system_monitor_processor_use";
                      name = "CPU";
                      min = 0;
                      max = 100;
                    }
                    {
                      entity = "sensor.system_monitor_memory_usage";
                      name = "RAM";
                      min = 0;
                      max = 100;
                    }
                  ];
                }
                {
                  type = "horizontal-stack";
                  cards = [
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_swap_free";
                      name = "Swap Free";
                      icon = "mdi:harddisk";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_processor_temperature";
                      name = "CPU Temp";
                      icon = "mdi:thermometer";
                      fill_container = true;
                      layout = "vertical";
                    }
                  ];
                }

                # === LOAD & DISK ===
                {
                  type = "horizontal-stack";
                  cards = [
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_load_1_min";
                      name = "Load 1m";
                      icon = "mdi:speedometer";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_load_5_min";
                      name = "Load 5m";
                      icon = "mdi:speedometer";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_load_15_min";
                      name = "Load 15m";
                      icon = "mdi:speedometer";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_disk_use";
                      name = "Disk Usage";
                      icon = "mdi:harddisk";
                      fill_container = true;
                      layout = "vertical";
                    }
                  ];
                }

                # === GPU ===
                {
                  type = "horizontal-stack";
                  cards = [
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.gpu_power";
                      name = "GPU Power";
                      icon = "mdi:flash";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.gpu_temperature";
                      name = "GPU Temp";
                      icon = "mdi:thermometer";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.gpu_utilization";
                      name = "GPU Util";
                      icon = "mdi:memory";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.gpu_memory_used";
                      name = "GPU Memory";
                      icon = "mdi:chip";
                      fill_container = true;
                      layout = "vertical";
                    }
                  ];
                }

                # === NETWORK ===
                {
                  type = "horizontal-stack";
                  cards = [
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_network_in_wlp5s0";
                      name = "WiFi In";
                      icon = "mdi:wifi";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_network_out_wlp5s0";
                      name = "WiFi Out";
                      icon = "mdi:wifi";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_network_in_tailscale0";
                      name = "Tailscale In";
                      icon = "mdi:vpn";
                      fill_container = true;
                      layout = "vertical";
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.system_monitor_network_out_tailscale0";
                      name = "Tailscale Out";
                      icon = "mdi:vpn";
                      fill_container = true;
                      layout = "vertical";
                    }
                  ];
                }

                # === SYSTEM INFO ===
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.system_monitor_last_boot";
                  name = "Last Boot";
                  icon = "mdi:clock-outline";
                }
              ];
            }
          ];
        }
      ];
    };
  };

  # Grant HA service access to NVIDIA GPU devices for nvidia-smi sensors
  # The default DevicePolicy=closed blocks all device access; punch holes for NVML
  systemd.services.home-assistant.serviceConfig.DeviceAllow = [
    "/dev/nvidia0 rwm"
    "/dev/nvidiactl rwm"
    "/dev/nvidia-modeset rwm"
    "/dev/nvidia-uvm rwm"
    "/dev/nvidia-uvm-tools rwm"
    "/dev/nvidia-caps/nvidia-cap1 r"
    "/dev/nvidia-caps/nvidia-cap2 r"
  ];
}
