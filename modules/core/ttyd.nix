{
  config,
  pkgs,
  lib,
  ...
}:

{
  # === ttyd Service ===
  services.ttyd = {
    enable = lib.mkDefault true;
    port = 7681;
    command = "${pkgs.bash}/bin/bash"; # systemd handles persistence
    username = "admin";
    passwordFile = pkgs.writeText "ttyd-password" "your-password";
    writeable = true;
    maxClients = 5;
    checkOrigin = true;
    clientOptions = {
      fontSize = "18";
      disableLeaveAlert = true;
      theme = {
        background = "#1a1a1a";
        foreground = "#ffffff";
      };
    };
    user = "ttyd";
  };

  # === Tailscale Serve Integration ===
  services.tailscale.serve = {
    enable = lib.mkDefault true;
    services = {
      ttyd = {
        endpoints = {
          "tcp:7681" = "http://localhost:7681";
        };
        advertised = true;
      };
    };
  };

  # === Firewall Configuration ===
  networking.firewall = {
    allowedTCPPorts = lib.mkMerge [
      config.networking.firewall.allowedTCPPorts or [ ]
      [ 7681 ]
    ];
  };

  # === Dedicated User ===
  users.users.ttyd = {
    isSystemUser = true;
    group = "ttyd";
  };
  users.groups.ttyd = { };
}
