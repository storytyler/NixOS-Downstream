{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  qmd = inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cfg = config.programs.qmd;
in
{
  options.programs.qmd = {
    enable = lib.mkEnableOption "qmd local corpus search engine";
    mcpPort = lib.mkOption {
      type = lib.types.port;
      default = 8181;
      description = "Port for the qmd MCP HTTP daemon";
    };
    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-update the qmd index via systemd timer";
    };
    updateInterval = lib.mkOption {
      type = lib.types.str;
      default = "*:0/15";
      description = "OnCalendar spec for qmd update timer";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      (_: {
        home.packages = [ qmd ];

        # Long-lived HTTP daemon — models stay loaded, shared across all opencode sessions.
        # Streamable HTTP transport (per the qmd README, exposed at /mcp).
        systemd.user.services.qmd-mcp = {
          Unit = {
            Description = "qmd MCP HTTP server (shared across opencode sessions)";
            After = [ "network-online.target" ];
            Wants = [ "network-online.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${qmd}/bin/qmd mcp --http --port ${toString cfg.mcpPort}";
            Restart = "on-failure";
            RestartSec = "5s";
            KillMode = "mixed";
            TimeoutStopSec = "30s";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };

        # Auto-update index on a timer.
        systemd.user.timers.qmd-update = lib.mkIf cfg.autoUpdate {
          Unit.Description = "Refresh qmd corpus index";
          Timer = {
            OnCalendar = cfg.updateInterval;
            Persistent = true;
            AccuracySec = "1min";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
        systemd.user.services.qmd-update = lib.mkIf cfg.autoUpdate {
          Unit.Description = "Refresh qmd corpus index (oneshot)";
          Service = {
            Type = "oneshot";
            ExecStart = "${qmd}/bin/qmd update";
          };
        };
      })
    ];
  };
}
