{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    (pkgs.writeShellScriptBin "ch" ''
      #!/usr/bin/env bash

      # Dynamic library path using stdenv (survives rebuilds!)
      export LD_LIBRARY_PATH="${pkgs.stdenv.cc.lib}/lib/:$LD_LIBRARY_PATH"

      # Copy config file if not present
      CONFIG_SRC="$HOME/NixOS/dev-shells/python/chunkhound/.chunkhound.json"
      CONFIG_DST="$PWD/.chunkhound.json"

      if [ ! -f "$CONFIG_DST" ] && [ -f "$CONFIG_SRC" ]; then
        cp "$CONFIG_SRC" "$CONFIG_DST"
      fi

      # Run chunkhound with all arguments
      exec ~/.local/bin/chunkhound "$@"
    '')
  ];
}
