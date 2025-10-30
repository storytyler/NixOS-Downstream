{ pkgs, lib, config, ... }:

{

    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    
    #Disable Docker Daemon For Rootless
    virtualisation.docker.enable = false;

    virtualisation.docker.daemon.settings = {
      data-root = "/home/player00/.Docker-Data";
      exec-opts = [ "native.cgroupdriver=systemd" ];
      cgroup-parent = "system.slice";
      dns = ["8.8.8.8" "1.1.1.1"];
      };

    systemd.services."user@".serviceConfig.Delegate = "cpu cpuset io memory pids";

    environment.systemPackages = with pkgs; [
      compose2nix
      lazydocker
    ];
}
