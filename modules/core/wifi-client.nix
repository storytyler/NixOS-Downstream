{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wifi-client;
in
{
  options.services.wifi-client = {
    enable = mkEnableOption "WiFi client configuration";

    ssid = mkOption {
      type = types.str;
      description = "WiFi network SSID to connect to";
    };

    password = mkOption {
      type = types.str;
      description = "WiFi network password";
    };

    interface = mkOption {
      type = types.str;
      default = "wlan0";
      description = "Wireless interface name";
    };

    priority = mkOption {
      type = types.int;
      default = 20;
      description = "Priority for the network connection";
    };
  };

  config = mkIf cfg.enable {
    networking.wireless = {
      enable = true;
      interfaces = [ cfg.interface ];
      networks = {
        "${cfg.ssid}" = {
          psk = cfg.password;
          priority = cfg.priority;
        };
      };
    };

    # Ensure wireless is enabled and not blocked
    networking.networkmanager.unmanaged = [ cfg.interface ];

    # Add wireless tools for debugging
    environment.systemPackages = with pkgs; [
      wireless_tools
      wpa_supplicant
    ];
  };
}