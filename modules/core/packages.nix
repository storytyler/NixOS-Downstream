{ pkgs, ... }:
{
  # TODO: review
  programs = {
    fuse.userAllowOther = true;
    mtr.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # appimage-run # Needed For AppImage Support
    # android-tools # Needed for working with android os
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    # gnome-disk-utility # Disk Partitioning and Mounting Utility
    jq # Json Formatting Utility
    bibata-cursors
    sddm-astronaut # Sddm Theme (Overlayed)
    kdePackages.qtsvg # Sddm Dependency
    kdePackages.qtmultimedia # Sddm Dependency
    kdePackages.qtvirtualkeyboard # Sddm Dependency
    # fzf # Fuzzy Finder
    # fd # Better Find
    git # Git
    gh # Github Authentication Client
    # libjxl # Support for JXL Images
    # microfetch # Small fetch (Blazingly fast)
    nix-prefetch-scripts # Find Hashes/Revisions of Nix Packages
    ripgrep # Improved Grep
    tldr # Improved Man
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    # cmatrix # Matrix Movie Effect In Terminal
    # cowsay # Great Fun Terminal Program
    # duf # Utility For Viewing Disk Usage In Terminal
    # dysk # Disk space util nice formattting
    # ffmpeg # Terminal Video / Audio Editing
    # glxinfo # needed for inxi diag util
    # inxi # CLI System Information Tool
    # libsForQt5.qt5.qtgraphicaleffects # Sddm Dependency (Old)
    # libnotify # For Notifications
    # lolcat # Add Colors To Your Terminal Command Output
    # lshw # Detailed Hardware Information
    # mpv # Incredible Video Player
    # ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt # Nix Formatter
    # nwg-displays # configure monitor configs via GUI
    # onefetch # provides zsaneyos build info on current system
    pavucontrol # For Editing Audio Levels & Devices
    # pciutils # Collection Of Tools For Inspecting PCI Devices
    # picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    # rhythmbox # audio player
    # socat # Needed For Screenshots
    usbutils # Good Tools For USB Devices
    # uwsm # Universal Wayland Session Manager (optional must be enabled)
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # waypaper # Change wallpaper
    wget # Tool For Fetching Files With Links
    # ytmdl # Tool For Downloading Audio From YouTube
    nodejs
    # devenv
    # devbox
    # shellify
    nmap
    # wireshark-cli
    iftop
    btop
    htop
    file # Program that shows the type of files
    tree # Command to produce a depth indented directory listing
  ];
}
