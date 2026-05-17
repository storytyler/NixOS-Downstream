# System Scripts

Custom utility scripts packaged as Nix derivations. 9 scripts total.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Rebuild system | `rebuild.nix` | Auto username sync + hardware detection + nixos-rebuild switch |
| Rollback system | `rollback.nix` | Interactive generation selection |
| App launcher | `launcher.nix` | Rofi multi-mode: drun/window/file/tmux/wallpaper/emoji/games/factcheck |
| Tmux sessions | `tmux-sessionizer.nix` | Development session management with fzf |
| Extract archives | `extract.nix` | Universal extraction (tar, zip, rar, 7z, etc.) |
| Driver info | `driverinfo.nix` | Vulkan GPU diagnostics |
| Power mgmt | `underwatt.nix` | Battery monitoring (**GTX 1080-specific**) |
| Hindsight backup | `hindsight-backup.nix` | Backup utility |
| Network utils | `network.nix` | Network management scripts |

## CONVENTIONS
- Scripts packaged as Nix derivations: `pkgs.writeShellScriptBin "name" ''...''`
- Dependencies declared inline: `${pkgs.dependency}/bin/dep`
- `default.nix` builds all scripts with shared `scriptArgs` pattern
- `rebuild` mutates `variables.nix` in-place via `sed` (no rollback on failure)
- `rebuild` supports both `$HOME/NixOS` and `/etc/nixos` locations
- `launcher` uses `${terminal}` variable for sub-commands
- Hyprland-specific scripts (18) live in `modules/desktop/hyprland/scripts/`, NOT here

## ANTI-PATTERNS
- DON'T bypass `rebuild` script - it handles username sync and hardware detection
- DON'T use relative paths for dependencies - always `${pkgs.package}/bin/name`
- DON'T use `underwatt` without verifying GPU compatibility (hardcoded for GTX 1080)
- DON'T run `rebuild` from agent sessions — user runs from terminal with sudo (codemem #93)
