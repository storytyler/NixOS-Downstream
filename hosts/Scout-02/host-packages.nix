{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    # github-desktop
    # kdePackages.kdeconnect-kde
    nodejs
    uv
    # nix-tree
    # gemini-cli
    # nurl
    # nix-init
    # nixd
  ];
}
