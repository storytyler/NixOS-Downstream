{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    github-desktop
    
    
    kdePackages.kate
    # kdePackages.kdeconnect-kde
    
    # CLI Tools
    pkgs.claude-code
    gemini-cli
    opencode-dev
    
    uv
    nix-tree

    # Package Building
    nurl
    nix-init

    # Languages
    python314
    python313Packages.aiofiles
    nodejs

    watchdog
    nixd
    gearlever
    deploy-rs
    tsx
    
    # Built By Nurl and Nix-Init
    (callPackage ../../pkgs/code-machine.nix {})
  ];
}
