{
  pkgs,
  lib,
  config,
  ...
}:
let
  host = config.networking.hostName;
  inherit (import ../../hosts/${host}/variables.nix) username;
in
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/${username}/.Docker-Data";
      exec-opts = [ "native.cgroupdriver=systemd" ];
      cgroup-parent = "system.slice";
      # dns = [ "192.168.1.122" ];
      live-restore = false;
      features.cdi = true;
    };
  };

  # Add user to docker group for sudo-less access
  users.users.${username}.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    compose2nix
    lazydocker
  ];

  home-manager.sharedModules = [
    (_: {
      xdg.configFile."lazydocker/config.yml".text = ''
        gui:
          theme:
            activeBorderColor:
              - "#8f8f8f"
              - bold
            inactiveBorderColor:
              - "#6b6b6b"
            searchingActiveBorderColor:
              - "#cfd3db"
              - bold
            optionsTextColor:
              - "#6da050"
          border: single
      '';
    })
  ];
}
