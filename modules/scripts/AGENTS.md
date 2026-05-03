# System Scripts

Custom utility scripts packaged as Nix derivations. 9 scripts total.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Rebuild system | `rebuild.nix` | Auto username sync + hardware detection + nixos-rebuild switch |
| Rollback system | `rollback.nix` | Interactive generation selection |
| App launcher | `launcher.nix` | Rofi multi-mode: drun/window/file/tmux/wallpaper/emoji/games |
| Tmux sessions | `tmux-sessionizer.nix` | Development session management |
| Extract archives | `extract.nix` | Universal extraction (tar, zip, rar, 7z, etc.) |
| Driver info | `driverinfo.nix` | Hardware diagnostics |
| Power mgmt | `underwatt.nix` | Battery monitoring (**GTX 1080-specific**) |
| Hindsight backup | `hindsight-backup.nix` | Backup utility |

## CONVENTIONS
- Scripts packaged as Nix derivations: `pkgs.writeShellScriptBin "name" ''...''`
- Dependencies declared inline: `${pkgs.dependency}/bin/dep`
- `default.nix` builds all scripts with shared `scriptArgs` pattern
- `rebuild` mutates `variables.nix` in-place via `sed` (no rollback on failure)

## ANTI-PATTERNS
- DON'T bypass `rebuild` script - it handles username sync and hardware detection
- DON'T use relative paths for dependencies - always `${pkgs.package}/bin/name`
- DON'T use `underwatt` without verifying GPU compatibility (hardcoded for GTX 1080)
