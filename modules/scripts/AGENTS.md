# System Scripts

Custom utility scripts packaged system-wide.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Rebuild system | `rebuild` script | Auto username sync + hardware detection |
| Rollback system | `rollback` script | Interactive generation selection |
| Tmux sessions | `tmux-sessionizer` | Development session management |
| Extract archives | `extract` | Universal archive extraction (tar, zip, rar, 7z, etc.) |
| Driver info | `driverinfo` | Hardware diagnostics |
| Power mgmt | `underwatt` | Battery monitoring, power saving |

## CONVENTIONS
- Scripts packaged as Nix derivations: `pkgs.writeShellScriptBin "name" ''...''`
- Dependencies declared inline: `${pkgs.dependency}/bin/dep`
- Installed through `environment.systemPackages` in module

## ANTI-PATTERNS
- DON'T bypass `rebuild` script - it handles username sync and hardware detection
- DON'T use relative paths for dependencies - always `${pkgs.package}/bin/name`
