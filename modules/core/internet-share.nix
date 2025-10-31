{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.internet-share;
in
{
  options.services.internet-share = {
    enable = mkEnableOption "Internet sharing (NAT) configuration";

    externalInterface = mkOption {
      type = types.str;
      description = "External interface connected to internet (e.g., wlan0)";
    };

    internalInterface = mkOption {
      type = types.str;
      description = "Internal interface to share internet on (e.g., eno1)";
    };

    internalIP = mkOption {
      type = types.str;
      default = "192.168.200.1";
      description = "IP address for internal interface";
    };

    internalPrefix = mkOption {
      type = types.int;
      default = 24;
      description = "Network prefix length for internal interface";
    };

    internalNetwork = mkOption {
      type = types.str;
      default = "192.168.200.0/24";
      description = "Internal network range for NAT";
    };
  };

  config = mkIf cfg.enable {
    # Enable IP forwarding
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # Configure internal interface with static IP
    networking.interfaces."${cfg.internalInterface}" = {
      ipv4.addresses = [
        {
          address = cfg.internalIP;
          prefixLength = cfg.internalPrefix;
        }
      ];
    };

    # Configure NAT using Context7-confirmed pattern
    networking.nat = {
      enable = true;
      internalInterfaces = [ cfg.internalInterface ];
      externalInterface = cfg.externalInterface;
    };

    # Add useful network tools for debugging
    environment.systemPackages = with pkgs; [
      iptables
      iproute2
    ];

    # Ensure NAT rules are applied
    networking.localCommands = mkAfter ''
      # Flush existing NAT rules to avoid conflicts
      ${pkgs.iptables}/bin/iptables -t nat -F POSTROUTING 2>/dev/null || true

      # Add NAT rule for internal network
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING \
        -s "${cfg.internalNetwork}" \
        -o "${cfg.externalInterface}" \
        -j MASQUERADE

      # Ensure forwarding is enabled
      echo 1 > /proc/sys/net/ipv4/ip_forward
    '';
  };
}