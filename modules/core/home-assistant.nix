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
      "wake_on_lan" # Wake on LAN (available, configure later)
      "webostv" # LG webOS TV (local)
      "met" # Weather
      "radio_browser"
      "shopping_list"
      "isal" # Fast compression
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
    };
  };

  # Access via Tailscale mesh only
}
