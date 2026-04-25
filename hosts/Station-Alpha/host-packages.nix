{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    # github-desktop

    # Multimedia
    ffmpeg

    # Needed for AI/ML GPU Processing
    nvidia-container-toolkit

    # LLM Platforms
    lmstudio

    # Speech-to-Text
    whisper-cpp
    # openai-whisper

    # Notation
    anytype

    # Coding Agents
    # pkgs.claude-code
    # gemini-cli
    pkgs.opencode

    # MCP Servers
    # portainer-mcp

    uv
    # nix-tree
    bun
    # pnpm

    # Package Building
    nurl
    # nix-init

    # Nix Analysis & Documentation
    manix
    flake-checker

    # Dev Shell Config
    nix-direnv
    direnv

    # Misc
    # watchdog
    nixd
    # gearlever
    # deploy-rs
    # tsx
    # zip
    # unzip

    google-chrome
    # Packages added for openclaw skills
    gogcli
    python3

    # Disk Install Method for btrfs on SSD
    # disko

    # Built By Nurl and Nix-Init
    # (callPackage ../../pkgs/code-machine.nix { })

  ];
}
