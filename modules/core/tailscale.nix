{ config, pkgs, ... }:
{
  # Tailscale Mesh Networking Configuration
  # Provides secure mesh network for all hosts with mobile app access

  environment.systemPackages = with pkgs; [
    tailscale # Tailscale client and daemon
    tscli # Tailscale CLI interface
    proton-vpn # Proton VPN GTK app for IP masking
  ];

  networking.nftables.enable = true;

  # Configure firewall to properly allow Tailscale traffic
  # Reference: https://wiki.nixos.org/wiki/Tailscale#Native_nftables_Support_(Modern_Setup)
  networking.firewall = {
    # Always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # Allow Tailscale UDP port through firewall
    allowedUDPPorts = [ 41641 ];
  };

  services.tailscale = {
    enable = true;
    # Enable routing features for exit nodes and subnet routers
    useRoutingFeatures = "both";
  };

  # Force tailscaled to use nftables (avoids iptables-compat issues)
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # Optimize boot with VPN - don't wait for network online
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}
