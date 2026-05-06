{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Pinned driver 590.48.01 with kernel 6.19+ compat patch.
  # Required for Windrose (UE5, D3D12) — 595.x crashes during VKD3D PSO compilation on Blackwell GPUs.
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "590.48.01";
    sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
    sha256_aarch64 = "sha256-FOz7f6pW1NGM2f74kbP6LbNijxKj5ZtZ08bm0aC+/YA=";
    openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
    settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
    persistencedSha256 = "sha256-wsNeuw7IaY6Qc/i/AzT/4N82lPjkwfrhxidKWUtcwW8=";
    patchesOpen = [
      (pkgs.fetchpatch {
        url = "https://github.com/CachyOS/CachyOS-PKGBUILDS/raw/d5629d64ac1f9e298c503e407225b528760ffd37/nvidia/nvidia-utils/kernel-6.19.patch";
        hash = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
      })
    ];
  };
in
{
  environment.sessionVariables = lib.optionalAttrs config.programs.hyprland.enable {
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # MOZ_DISABLE_RDD_SANDBOX = 1; # Potential security risk

    __GL_GSYNC_ALLOWED = "1"; # GSync
    __GL_VRR_ALLOWED = "1"; # VRR
    # __GL_MaxFramesAllowed = "1"; # Reduces input lag
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ]; # or "nvidiaLegacy470", etc.
  boot.kernelParams = lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"

    # "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1" # Experimental: reduce latency
  ];
  # Early loading of NVIDIA modules for SDDM Wayland compatibility
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
    "nvidia_uvm"
  ];
  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      # 5060 TI on station alpha requires open drivers
      open = true;
      # nvidiaPersistenced = true;
      nvidiaSettings = false;
      powerManagement.enable = true; # Fixes sleep/suspend
      modesetting.enable = true; # Modesetting is required.

      package = nvidiaDriverChannel;
    };
    graphics = {
      enable = true;
      # package = nvidiaDriverChannel;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    cudaSupport = true;
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };
}
