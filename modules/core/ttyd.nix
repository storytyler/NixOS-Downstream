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
    entrypoint = [ "${pkgs.bash}/bin/bash" ]; # systemd handles persistence
    username = "player00";
    passwordFile = pkgs.writeText "ttyd-password" "unicorn";
    writeable = true;
    maxClients = 5;
    checkOrigin = true;
    clientOptions = {
      fontSize = "18";
      disableLeaveAlert = "true";
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

  # === Dedicated User ===
  users.users.ttyd = {
    isSystemUser = true;
    group = "ttyd";
  };
  users.groups.ttyd = { };
}
