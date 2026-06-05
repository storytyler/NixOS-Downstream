{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  qmd-unwrapped = inputs.qmd.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Re-wrap qmd with CUDA runtime libs in LD_LIBRARY_PATH. The qmd-mcp
  # fork (PR #574) already adds sqlite + glibc + libstdc++ to the wrapper;
  # we add cudart + cublas + libcuda + libggml-base so the CUDA prebuilt
  # can load. These come from already-closed store paths (cudaSupport = true
  # pulls them in transitively) — nothing new gets added to the system
  # closure, only to qmd's wrapper.
  # Patch the upstream qmd wrapper (PR #574) to add CUDA runtime libs
  # to LD_LIBRARY_PATH. The upstream wrapper hardcodes sqlite+glibc+libstdc++
  # via `export LD_LIBRARY_PATH=...`, which would replace any LD_LIBRARY_PATH
  # we set from a higher-level wrapper. So we modify the upstream wrapper
  # in-place to prepend our CUDA paths to its existing LD_LIBRARY_PATH value.
  qmd =
    pkgs.runCommand "qmd-cuda"
      {
        nativeBuildInputs = [ pkgs.bash ];
      }
      ''
        mkdir -p $out/bin
        cp ${qmd-unwrapped}/bin/qmd $out/bin/qmd
        chmod +w $out/bin/qmd
        substituteInPlace $out/bin/qmd \
          --replace-fail "export LD_LIBRARY_PATH='" "export LD_LIBRARY_PATH='${
            lib.makeLibraryPath [
              pkgs.cudaPackages.cuda_cudart
              pkgs.cudaPackages.libcublas
            ]
          }:/run/opengl-driver/lib:${qmd-unwrapped}/lib/qmd/node_modules/@node-llama-cpp/linux-x64-cuda/bins/linux-x64-cuda:"
      '';

  inotify = pkgs.inotify-tools;

  # Watches all registered qmd collection directories for filesystem
  # changes and re-indexes on the fly.  Reads collection paths
  # from the YAML config (the only source of filesystem paths —
  # `qmd collection list` prints qmd:// URIs, not filesystem paths).
  # Adding a new collection requires restarting this service.
  qmd-watch = pkgs.writeShellScriptBin "qmd-watch" ''
        set -euo pipefail

        QMD="${qmd}/bin/qmd"
        INOTIFYWAIT="${inotify}/bin/inotifywait"
        CFG="''${XDG_CONFIG_HOME:-$HOME/.config}/qmd/index.yml"

        if [ ! -f "$CFG" ]; then
          echo "qmd-watch: no $CFG, sleeping until next restart"
          exec sleep infinity
        fi

    mapfile -t DIRS < <(awk -F': *' '
      /^[[:space:]]*path:[[:space:]]*/ {
        $1 = ""
        sub(/^[[:space:]]+/, "", $0)
        print
      }
    ' "$CFG")

        if [ ''${#DIRS[@]} -eq 0 ]; then
          echo "qmd-watch: no collections registered, sleeping until next restart"
          exec sleep infinity
        fi

        echo "qmd-watch: watching ''${#DIRS[@]} collection directory(ies): ''${DIRS[*]}"

    $INOTIFYWAIT -r -m \
      -e modify -e create -e delete -e moved_to -e moved_from -e close_write \
      --format '%w%f|%e' "''${DIRS[@]}" \
    | while IFS='|' read -r _path _event; do
        case "$_event" in
          DELETE* | MOVED_FROM*) needs_cleanup=1 ;;
        esac
        sleep 2
        while IFS='|' read -r -t 1 _ep _ee 2>/dev/null; do
          case "$_ee" in
            DELETE* | MOVED_FROM*) needs_cleanup=1 ;;
          esac
        done
        echo "qmd-watch: reindexing ($QMD update) ..."
        $QMD update --quiet 2>/dev/null || true
        echo "qmd-watch: embedding ($QMD embed) ..."
        $QMD embed 2>/dev/null || true
        if [ "''${needs_cleanup:-0}" = 1 ]; then
          echo "qmd-watch: delete/move detected, cleaning orphan vectors ($QMD cleanup) ..."
          $QMD cleanup 2>/dev/null || true
          needs_cleanup=0
        fi
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
          # Force CUDA device (qmd's auto picks CPU when it can't load
          # the CUDA prebuilt; with the wrapper's LD_LIBRARY_PATH fix,
          # CUDA loads cleanly).
          Environment = "QMD_LLAMA_GPU=cuda";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      # Watches collection directories via inotify and re-indexes on
      # file changes.  Paths are read from `~/.config/qmd/index.yml`
      # at startup, so adding/removing collections takes effect on
      # next service restart.
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
          # Watch daemon calls `qmd update` which embeds new files —
          # also needs the GPU backend.
          Environment = "QMD_LLAMA_GPU=cuda";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ];
}
