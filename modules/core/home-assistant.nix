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
      "met" # Weather
      "radio_browser"
      "shopping_list"
      "isal" # Fast compression
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
      };

      # Wake on LAN - add MAC addresses later via UI or here
      wake_on_lan = { };

      http = {
        server_host = "0.0.0.0";
        server_port = 8234;
      };

      # System monitor sensors
      sensor = [
        {
          platform = "systemmonitor";
          resources = [
            { type = "processor_use"; }
            { type = "processor_temperature"; }
            { type = "memory_use"; }
            { type = "memory_free"; }
            { type = "memory_use_percent"; }
            { type = "disk_use_percent"; arg = "/"; }
            { type = "disk_use"; arg = "/"; }
            { type = "disk_free"; arg = "/"; }
            { type = "swap_use_percent"; }
            { type = "load_1m"; }
            { type = "load_5m"; }
            { type = "load_15m"; }
            { type = "last_boot"; }
            { type = "network_out"; arg = "eth0"; }
            { type = "network_in"; arg = "eth0"; }
          ];
        }
      ];
    };

    lovelaceConfig = {
      views = [
        {
          title = "Dashboard";
          path = "dashboard";
          cards = [
            # Weather card
            {
              type = "custom:clock-weather-card";
              entity = "weather.home";
              title = "Weather";
            }
            # System metrics - CPU
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.processor_use";
              name = "CPU Usage";
              icon = "mdi:cpu-64-bit";
            }
            # System metrics - Memory
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.memory_use_percent";
              name = "Memory Usage";
              icon = "mdi:memory";
            }
            # System metrics - Disk
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.disk_use_percent";
              name = "Disk Usage";
              icon = "mdi:harddisk";
            }
            # System metrics - Load
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.load_1m";
              name = "Load (1m)";
              icon = "mdi:gauge";
            }
            # CPU Temperature
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.processor_temperature";
              name = "CPU Temperature";
              icon = "mdi:thermometer";
            }
          ];
        }
      ];
    };
  };

  # Access via Tailscale mesh only
}
