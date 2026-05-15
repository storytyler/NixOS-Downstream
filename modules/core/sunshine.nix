{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (import ../../hosts/${config.networking.hostName}/variables.nix) username;
in
{
  # Sunshine — Self-hosted game streaming server (Moonlight client)
  # Streams display + input over LAN or Tailscale for remote play

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Required for DRM/KMS capture on Wayland (Hyprland)
    openFirewall = true; # Opens ports 47984-47990 TCP, 47998-48000 UDP
  };

  # User group memberships for Sunshine virtual input + GPU access
  users.users.${username} = {
    extraGroups = [
      "uinput" # Create virtual mouse/keyboard for remote input
      "render" # GPU render node access for NVENC encoding
    ];
  };

  # Ensure uinput kernel module is loaded (also in games.nix, but safe to duplicate)
  hardware.uinput.enable = true;
}
