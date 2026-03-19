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

    # CLI Agent TUIs
    # pkgs.claude-code
    # gemini-cli
    pkgs.opencode

    # MCP Servers
    portainer-mcp

    uv
    # nix-tree
    bun
    # pnpm

    # Containers (for running non-Nix packages like OpenWork desktop)
    # distrobox

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
    gogcli

    # Disk Install Method for btrfs on SSD
    # disko

    # Built By Nurl and Nix-Init
    # (callPackage ../../pkgs/code-machine.nix { })

  ];
}
