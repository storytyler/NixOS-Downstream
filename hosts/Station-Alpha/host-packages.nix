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

    # Web Terminal
    ttyd

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

    # Built By Nurl and Nix-Init
    # (callPackage ../../pkgs/code-machine.nix { })

  ];
}
