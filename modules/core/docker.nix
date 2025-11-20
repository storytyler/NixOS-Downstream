  {
    pkgs,
    lib,
    config,
    ...
  }:

  {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/player00/.Docker-Data";
        exec-opts = [ "native.cgroupdriver=systemd" ];
        cgroup-parent = "system.slice";
        dns = [ "192.168.1.122" ];
      };
    };

    # Add user to docker group for sudo-less access
    users.users.player00.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      compose2nix
      lazydocker
    ];
  }