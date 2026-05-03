# Core System Modules

Essential system services and configuration. 32 modules, always loaded by all hosts.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Boot config | `boot.nix` | GRUB, kernel params, AppImage support |
| System config | `system.nix` | Nix daemon, overlays wiring, locale, timezone, caches |
| User mgmt | `users.nix` | User creation, Home Manager integration, shell selection |
| Network config | `network.nix` | Hostname, NetworkManager |
| Security | `security.nix` | Polkit, RTKit, kernel hardening, ACME |
| Services | `services.nix` | PipeWire (low-latency), SSH, Bluetooth, USB mounting |
| Packages | `packages.nix` | Base system packages (rg, jq, git, btop, etc.) |
| Docker | `docker.nix` | Docker daemon, compose2nix, lazydocker |
| Display manager | `sddm.nix` | SDDM, reads `sddmTheme` from host variables |
| Shell config | `bash.nix` / `zsh.nix` | Shell environment, selected via `variables.shell` |
| VPN | `tailscale.nix` | Tailscale VPN (Station-Alpha only) |
| Smart home | `home-assistant.nix` | Home Assistant (Station-Alpha only) |
| Gaming | `games.nix` | Conditionally loaded via `lib.optional vars.games` |
| AI services | `model-runner.nix`, `chunkhound.nix` | AI model runner, code search (Station-Alpha) |

## CONVENTIONS
- Core modules imported individually by each host's `configuration.nix` (NOT via `default.nix`)
- `default.nix` exists but is unused — hosts inline their own import lists
- `system.nix` activates overlays: `nixpkgs.overlays = builtins.attrValues overlays`
- `users.nix` sets up Home Manager as NixOS module with `useGlobalPkgs = true`
- Variables consumed via `let inherit (import ../../hosts/${host}/variables.nix) ...`

## ANTI-PATTERNS
- DON'T put host-specific values in core modules - use variables
- DON'T duplicate packages across core and program modules
- DON'T change `system.stateVersion` from "23.11"
