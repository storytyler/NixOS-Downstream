{ pkgs, config, ... }:
let
  host = config.networking.hostName;
  inherit (import ../../hosts/${host}/variables.nix) username;
in
{
  # Allow nixos-facter (read-only hardware enumeration) to run without sudo password.
  # This is safe — nixos-facter only reads /sys and /proc to generate a JSON hardware
  # report. It does not modify system state, install packages, or access secrets.
  security.sudo.extraRules = [
    {
      users = [ "${username}" ];
      commands = [
        {
          command = "${pkgs.nixos-facter}/bin/nixos-facter";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
