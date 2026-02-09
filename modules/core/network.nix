{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    # NetworkManager handles all network configuration automatically.
    # No traffic control or QoS shaping applied.
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iproute2
  ];
}
