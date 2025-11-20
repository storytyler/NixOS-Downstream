{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    # github-desktop
    # kdePackages.kate
    # kdePackages.kdeconnect-kde
    pkgs.claude-code
    # nodejs
    # uv
    nix-tree
    # gemini-cli
    # nurl
    # nix-init
    nixd
  ];
}
