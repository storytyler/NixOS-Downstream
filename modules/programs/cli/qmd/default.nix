{ inputs, pkgs, ... }:
let
  qmd = inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default;
  inotify = pkgs.inotify-tools;

  # Watches all registered qmd collection directories for filesystem
  # changes and re-indexes on the fly.  Reads collection paths
  # dynamically from `qmd collection list` so it adapts when the user
  # adds or removes collections.
  qmd-watch = pkgs.writeShellScriptBin "qmd-watch" ''
    set -euo pipefail

    QMD="${qmd}/bin/qmd"
    INOTIFYWAIT="${inotify}/bin/inotifywait"

    # Collect paths from qmd; fall back to a harmless empty loop
    mapfile -t DIRS < <($QMD collection list 2>/dev/null | grep -oP '(?<=→\s)/\S+' || true)

    if [ ''${#DIRS[@]} -eq 0 ]; then
      echo "qmd-watch: no collections registered, sleeping until next restart"
      exec sleep infinity
    fi

    echo "qmd-watch: watching ''${#DIRS[@]} collection directory(ies): ''${DIRS[*]}"

    $INOTIFYWAIT -r -m -e modify -e create -e delete -e moved_to -e moved_from \
      --format '%w' "''${DIRS[@]}" \
    | while read -r _changed; do
        # Debounce: wait a short window so batch writes produce one update
        sleep 2
        # Only update if events are still arriving (read with timeout)
        while read -r -t 1 _extra 2>/dev/null; do true; done
        echo "qmd-watch: reindexing ($QMD update) ..."
        $QMD update --quiet 2>/dev/null || true
      done
  '';
in
{
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
          ExecStart = "${qmd}/bin/qmd mcp --http --port 8181";
          Restart = "on-failure";
          RestartSec = "5s";
          KillMode = "mixed";
          TimeoutStopSec = "30s";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      # Watches collection directories via inotify and re-indexes on
      # file changes.  Paths are read from `qmd collection list` at
      # startup, so adding/removing collections takes effect on next
      # service restart.
      systemd.user.services.qmd-watch = {
        Unit = {
          Description = "Watch qmd collections and reindex on file changes";
          After = [ "qmd-mcp.service" ];
          Wants = [ "qmd-mcp.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${qmd-watch}/bin/qmd-watch";
          Restart = "on-failure";
          RestartSec = "10s";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}
