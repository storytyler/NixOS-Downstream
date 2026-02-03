{ config, pkgs, ... }:
{
  # Tailscale Mesh Networking Configuration
  # Provides secure mesh network for all hosts with mobile app access

  environment.systemPackages = with pkgs; [
    tailscale # Tailscale client and daemon
    tscli # Tailscale CLI interface
    protonvpn-gui # Proton VPN GTK app for IP masking
  ];

  networking.nftables.enable = true;

  services.tailscale = {
    enable = true;
    # Enable routing features for exit nodes and subnet routers
    useRoutingFeatures = "both";
  };

  networking.firewall = {
    # Allow Tailscale traffic through firewall
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ]; # Tailscale default port
    # Critical for exit node functionality - prevents reverse path filter dropping traffic
    checkReversePath = "loose";
  };

  # Force tailscaled to use nftables (avoids iptables-compat issues)
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # Optimize boot with VPN - don't wait for network online
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}
