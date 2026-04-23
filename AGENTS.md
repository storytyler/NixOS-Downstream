# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-13
**Commit:** 7f5a192
**Branch:** main

## OVERVIEW
NixOS configuration using flakes with variables-driven architecture for flexible system management. 575 files across 4 hosts with 46 dev-shell templates. Core system in Nix + Python dev environment (Mimir, hindsight-mcp, general-agentic-memory).

## STRUCTURE
```
./
├── modules/
│   ├── core/       # Boot, networking, security, essential system
│   ├── hardware/   # GPU drivers (nvidia/amdgpu/intel/nvk), storage
│   ├── desktop/    # Window managers (hyprland, i3-gaps, gnome, plasma6)
│   ├── programs/   # Applications by category (browser, cli, editor, media, terminal)
│   ├── scripts/    # Custom utilities (rebuild, rollback, tmux-sessionizer)
│   └── themes/     # Wallpapers, icons, color schemes
├── hosts/          # 4 hosts: Default, Scout-02, Station-Alpha, Subrelay-01
├── dev-shells/    # 46 language templates + python/ (full project)
├── overlays/       # Custom package overlays (pokego, portainer-mcp)
└── flake.nix      # Central flake with mkHost function
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Change config | `hosts/{host}/variables.nix` | Single source of truth for 17 variables |
| Rebuild system | `rebuild` script | Auto-updates username + hardware detection |
| Python dev | `dev-shells/python/` | Mimir, hindsight-mcp, general-agentic-memory |
| Add program | `modules/programs/{category}/` | Use `lib.mkIf (config.variables.X == "Y")` |
| Add host | Copy `hosts/Default/` → add to `flake.nix` | Register in `nixosConfigurations` |
| GPU issues | `modules/hardware/video/${vars.videoDriver}.nix` | CRITICAL for boot |

## CONVENTIONS
- **Variables-Driven**: `hosts/{host}/variables.nix` controls 17 options (desktop, terminal, browser, editor, videoDriver, games, etc.)
- **Conditional Imports**: `./desktop/${vars.desktop}`, `./hardware/video/${vars.videoDriver}.nix`, `./programs/browser/${vars.browser}`
- **Flake Structure**: `mkHost "HostName"` in `flake.nix` → `nixosConfigurations.{HostName}`
- **Overlays**: Custom packages via `overlays/default.nix` with host-specific injection

## ANTI-PATTERNS (THIS PROJECT)
- DON'T hardcode host-specific values in modules - use variables
- DON'T modify hardware-configuration.nix manually - it's auto-generated
- DON'T bypass the `rebuild` script - it handles username sync and hardware detection
- DON'T duplicate packages across core and program modules
- DON'T use relative paths in scripts - always `${pkgs.package}/bin/name`

## UNIQUE STYLES
- Desktop/editor/browser/terminal switching via single variable change
- GPU driver selection via `videoDriver` (nvidia/amdgpu/intel/nvk) - CRITICAL for boot
- 4 hosts sharing modules with host-specific `variables.nix`
- 46 dev-shell templates: `nix flake init -t .#{template}`
- Python dev-shell is full project (not template) with Mimir/LightAgent framework

## COMMANDS
```bash
nix fmt                    # Format all Nix files (nixfmt-tree)
nix flake check            # Validate flake config
nix flake update           # Update all flake inputs
rebuild                    # Enhanced rebuild: username sync + hardware detection
rollback                   # System rollback utility
nix develop -t .#python    # Enter Python dev shell
```

## NOTES
- **KNOWN BUG**: `hosts/Default/configuration.nix` line 63 has inverted games logic (`vars.games == false` should be `== true`)
- `videoDriver` is CRITICAL - wrong value causes boot failure
- `rebuild` supports both `$HOME/NixOS` and `/etc/nixos` locations
- Subdirectory AGENTS.md: modules/{programs,core,scripts,desktop,hardware}, dev-shells/python{,/Mimir}
