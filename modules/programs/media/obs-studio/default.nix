{ pkgs, ... }:
{
  # System-level: Virtual camera support (v4l2loopback kernel module)
  # Allows OBS output to be used as webcam in other apps (Zoom, Discord, etc.)
  programs.obs-studio.enableVirtualCamera = true;

  home-manager.sharedModules = [
    (_: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          # Wayland support - essential for Hyprland
          wlrobs

          # Hardware encoding - uses nvidia-vaapi-driver for NVENC on NVIDIA GPUs
          obs-vaapi

          # Vulkan capture support
          obs-vkcapture

          # Audio capture via PipeWire
          obs-pipewire-audio-capture

          # Smooth scene transitions
          obs-move-transition

          # Multi-platform streaming (stream to multiple RTMP destinations)
          obs-multi-rtmp
        ];
      };
    })
  ];
}
