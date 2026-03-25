# Core System Modules

Essential system services and configuration.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Boot config | `modules/core/boot.nix` | Bootloader, kernel settings |
| Network config | `modules/core/network.nix` | Networking, firewall, DNS |
| Shell config | `modules/core/bash.nix` | Bash environment, aliases |
| Packages | `modules/core/packages.nix` | Base system packages |
| Fonts | `modules/core/fonts.nix` | System-wide font configuration |
| Docker | `modules/core/docker.nix` | Docker daemon and daemon configuration |
| Display manager | `modules/core/sddm.nix` | Login/display manager setup |

## CONVENTIONS
- Core modules imported directly into host configuration (not conditional)
- Use `lib.assertions` for validation with descriptive errors
- Base packages defined in `packages.nix`

## ANTI-PATTERNS
- DON'T put host-specific values in core modules - use variables
- DON'T duplicate packages across core and program modules
