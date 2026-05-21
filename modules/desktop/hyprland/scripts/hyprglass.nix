{
  pkgs,
  hyprglass,
  ...
}:
pkgs.writeShellScriptBin "hyprglass" ''
  hyprctl plugin load ${hyprglass}/lib/libhyprglass.so 2>&1 || true
''
