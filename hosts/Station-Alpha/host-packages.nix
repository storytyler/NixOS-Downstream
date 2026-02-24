{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    # github-desktop

    # Needed for AI/ML GPU Processing
    nvidia-container-toolkit

    # LLM Platforms
    lmstudio

    # Notation
    anytype

    # kdePackages.kate
    kdePackages.kdeconnect-kde

    # CLI Agent TUIs
    # pkgs.claude-code
    # gemini-cli
    pkgs.opencode

    uv
    # nix-tree
    bun

    # Package Building
    # nurl
    # nix-init

    # Dev Shell Config
    nix-direnv
    direnv

    # Translation
    # pandoc # file to Markdown

    # Misc
    # watchdog
    nixd
    # gearlever
    # deploy-rs
    # tsx
    # zip
    # unzip

    # Disk Install Method for btrfs on hosts with SSD
    # disko

    # VS Code in Browser
    code-server

    # RGB Control
    openrgb-with-all-plugins
    xcb-util-cursor # Qt xcb platform plugin dependency

    # Built By Nurl and Nix-Init
    # (callPackage ../../pkgs/code-machine.nix { })

  ];

  # Allow OpenRGB to run without sudo
  services.udev.packages = [ pkgs.openrgb ];
}
