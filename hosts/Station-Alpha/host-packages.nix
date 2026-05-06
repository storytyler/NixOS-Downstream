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
    # whisper-cpp
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

    # Nix CLI Tools
    nix-direnv
    direnv
    nixd

    # Nix CLI Packages for Agent Skills
    nurl
    nix-init
    optnix
    flake-checker
    dix
    nix-diff
    nixos-facter

    # Misc
    # watchdog
    # gearlever
    # deploy-rs
    # tsx
    # zip
    # unzip

    microsoft-edge
    # Packages added for openclaw skills
    gogcli
    python3

    # Disk Install Method for btrfs on SSD
    # disko

    # Built By Nurl and Nix-Init
    # (callPackage ../../pkgs/code-machine.nix { })

  ];
}
