{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    github-desktop

    # Backup Browser
    chromium

    kdePackages.kate
    # kdePackages.kdeconnect-kde

    # CLI Tools
    pkgs.claude-code
    gemini-cli
    pkgs.opencode

    uv
    nix-tree
    bun

    # Package Building
    nurl
    nix-init

    # Dev Shell Config
    nix-direnv
    direnv

    # Translation
    pandoc # file to Markdown

    # Misc
    watchdog
    nixd
    gearlever
    deploy-rs
    tsx
    zip
    unzip

    # Built By Nurl and Nix-Init
    (callPackage ../../pkgs/code-machine.nix { })

  ];
}
