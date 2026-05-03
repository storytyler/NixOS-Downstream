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
      "systemmonitor" # Local system metrics (CPU, RAM, disk, etc.) - SETUP VIA UI ONCE, then persists
      "wake_on_lan" # Wake on LAN (available, configure later)
      "webostv" # LG webOS TV (local)
      "met" # Weather
      "radio_browser"
      "shopping_list"
      "isal" # Fast compression
      "command_line" # For GPU sensors via nvidia-smi
    ];

    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      clock-weather-card
      card-mod
      mushroom
      apexcharts-card
      bubble-card
    ];

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

      # Weather provider - met (Norwegian Meteorological Institute)
      # No config needed - uses lat/long from homeassistant
      weather = {
        met = {
          api_key = ""; # Not required for met.no
        };
      };

      # GPU Command Sensors via nvidia-smi
      # Query: power.draw, temperature.gpu, utilization.gpu, memory.used, memory.total, clock.sm
      command_line = {
        sensors = [
          {
            name = "GPU Power";
            command = "nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits";
            unit_of_measurement = "W";
            scan_interval = 30;
          }
          {
            name = "GPU Temperature";
            command = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
            unit_of_measurement = "°C";
            scan_interval = 30;
          }
          {
            name = "GPU Utilization";
            command = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
            unit_of_measurement = "%";
            scan_interval = 30;
          }
          {
            name = "GPU Memory Used";
            command = "nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits";
            unit_of_measurement = "MB";
            scan_interval = 30;
          }
          {
            name = "GPU Memory Total";
            command = "nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits";
            unit_of_measurement = "MB";
            scan_interval = 30;
          }
          {
            name = "GPU Clock";
            command = "nvidia-smi --query-gpu=clock.sm --format=csv,noheader,nounits";
            unit_of_measurement = "MHz";
            scan_interval = 60;
          }
        ];
      };
    };

    lovelaceConfig = {
      title = "System Monitor";
      theme = "mushroom";
      background = "#0f0f0f";
      views = [
        {
          title = "System Overview";
          path = "overview";
          cards = [
            # === WEATHER SECTION ===
            {
              type = "custom:clock-weather-card";
              entity = "weather.home";
              title = "Weather";
              hourly_forecast = true;
              no_forecast = false;
            }

            # === SYSTEM METRICS ROW ===
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.processor_use";
                  name = "CPU";
                  icon = "mdi:cpu-64-bit";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.memory_use_percent";
                  name = "Memory";
                  icon = "mdi:memory";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.disk_use_percent";
                  name = "Disk";
                  icon = "mdi:harddisk";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.processor_temperature";
                  name = "CPU Temp";
                  icon = "mdi:thermometer";
                  fill_container = true;
                  layout = "vertical";
                }
              ];
            }

            # === LOAD AVERAGES ===
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.load_1m";
                  name = "Load 1m";
                  icon = "mdi:gauge";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.load_5m";
                  name = "Load 5m";
                  icon = "mdi:gauge";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.load_15m";
                  name = "Load 15m";
                  icon = "mdi:gauge";
                  fill_container = true;
                  layout = "vertical";
                }
              ];
            }

            # === GPU SECTION ===
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
                  # Use template to show "used / total" format
                }
              ];
            }

            # === NETWORK SECTION ===
            {
              type = "markdown";
              title = "Network";
              content = "## Network Interfaces";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.wlp5s0_network_in";
                  name = "WiFi In";
                  icon = "mdi:wifi";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.wlp5s0_network_out";
                  name = "WiFi Out";
                  icon = "mdi:wifi";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.tailscale0_network_in";
                  name = "Tailscale In";
                  icon = "mdi:vpn";
                  fill_container = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-entity-card";
                  entity = "sensor.tailscale0_network_out";
                  name = "Tailscale Out";
                  icon = "mdi:vpn";
                  fill_container = true;
                  layout = "vertical";
                }
              ];
            }

            # === SYSTEM INFO ===
            {
              type = "markdown";
              title = "System Info";
              content = "## System Information";
            }
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.last_boot";
              name = "Last Boot";
              icon = "mdi:clock-outline";
            }
          ];
        }
      ];
    };
  };

  # Access via Tailscale mesh only
}
