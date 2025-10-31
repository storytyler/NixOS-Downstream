{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.internet-client;
in
{
  options.services.internet-client = {
    enable = mkEnableOption "Internet client configuration";

    interface = mkOption {
      type = types.str;
      description = "Interface to configure for receiving internet";
    };

    ipAddress = mkOption {
      type = types.str;
      default = "192.168.200.100";
      description = "Static IP address for this client";
    };

    prefixLength = mkOption {
      type = types.int;
      default = 24;
      description = "Network prefix length";
    };

    gateway = mkOption {
      type = types.str;
      default = "192.168.200.1";
      description = "Default gateway (usually the internet-sharing server)";
    };
  };

  config = mkIf cfg.enable {
    # Configure interface with static IP
    networking.interfaces."${cfg.interface}" = {
      ipv4.addresses = [
        {
          address = cfg.ipAddress;
          prefixLength = cfg.prefixLength;
        }
      ];
    };

    # Set default gateway
    networking.defaultGateway = {
      address = cfg.gateway;
      interface = cfg.interface;
    };

    # Add network tools for debugging
    environment.systemPackages = with pkgs; [
      iproute2
    ];

    # Ensure interface is configured properly
    systemd.network.wait-online.enable = mkForce false;
  };
}