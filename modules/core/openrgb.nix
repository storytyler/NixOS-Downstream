{ pkgs, config, ... }:
let
  host = config.networking.hostName;
  inherit (import ../../hosts/${host}/variables.nix) username;
in
{
  # Enable I2C for RGB controller communication
  hardware.i2c.enable = true;

  # Load i2c-dev kernel module
  boot.kernelModules = [ "i2c-dev" ];

  # OpenRGB service with all plugins
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "intel";
  };

  # Add user to i2c group for SMBus access (required for RAM RGB detection)
  users.users.${username}.extraGroups = [ "i2c" ];
}
