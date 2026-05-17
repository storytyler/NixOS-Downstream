# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-17
**Commit:** 826472e
**Branch:** main

## OVERVIEW
NixOS configuration using flakes with variables-driven architecture for flexible system management. 568 files across 4 hosts with 46 dev-shell templates. Core system in Nix (Lua-based Hyprland config) + Python dev environment (hindsight-mcp).

## STRUCTURE
```
./
├── modules/
│   ├── core/       # Boot, networking, security, essential system (34 modules)
│   ├── hardware/   # GPU drivers (nvidia/amdgpu/intel/nvk), storage
│   ├── desktop/    # Window managers (hyprland, gnome)
│   ├── programs/   # Applications by category (browser, cli, editor, media, terminal)
│   ├── scripts/    # Custom utilities (rebuild, rollback, tmux-sessionizer)
│   └── themes/     # Catppuccin, Dracula, rose-pine + wallpapers
├── hosts/          # 4 hosts: Default, Scout-02, Station-Alpha, Subrelay-01
├── dev-shells/    # 46 language templates + python/ (full project)
├── overlays/       # Custom package overlays (pokego, portainer-mcp)
├── pkgs/           # Custom Nix package definitions
└── flake.nix      # Central flake with mkHost function
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Change config | `hosts/{host}/variables.nix` | Single source of truth for 17 variables |
| Rebuild system | `rebuild` script | Auto-updates username + hardware detection |
| Python dev | `dev-shells/python/` | hindsight-mcp (Python 3.13 dev shell) |
| Add program | `modules/programs/{category}/` | Use `lib.mkIf (config.variables.X == "Y")` |
| Add host | Copy `hosts/Default/` → add to `flake.nix` | Register in `nixosConfigurations` |
| GPU issues | `modules/hardware/video/${vars.videoDriver}.nix` | CRITICAL for boot |
| Custom package | `pkgs/{name}.nix` + register in `pkgs/default.nix` | Auto-overlayed into nixpkgs |
| Dev shell template | `dev-shells/{lang}/flake.nix` | Register in `dev-shells/default.nix` |

## CONVENTIONS
- **Variables-Driven**: `hosts/{host}/variables.nix` controls 20+ options (desktop, bar, terminal, browser, editor, videoDriver, games, etc.)
- **Conditional Imports**: `./desktop/${vars.desktop}`, `./hardware/video/${vars.videoDriver}.nix`, `./programs/browser/${vars.browser}`
- **Flake Structure**: `mkHost "HostName"` in `flake.nix` → `nixosConfigurations.{HostName}`
- **Overlays**: Custom packages via `overlays/default.nix` with host-specific injection
- **Home Manager**: Loaded as NixOS module (`home-manager.sharedModules` pattern for program configs)
- **Script Pattern**: `pkgs.writeShellScriptBin "name" ''...''` with `${pkgs.dep}/bin/dep` for deps
- **Browser Pattern**: Firefox derivatives share structure: `default.nix` + `settings.nix` + `bookmarks.nix` + `search.nix` + `policies.nix`

## ANTI-PATTERNS (THIS PROJECT)
- DON'T hardcode host-specific values in modules - use variables
- DON'T modify hardware-configuration.nix manually - it's auto-generated
- DON'T bypass the `rebuild` script - it handles username sync and hardware detection
- DON'T duplicate packages across core and program modules
- DON'T use relative paths in scripts - always `${pkgs.package}/bin/name`
- DON'T change `system.stateVersion` - it's pinned at 23.11

## UNIQUE STYLES
- Desktop/editor/browser/terminal switching via single variable change
- GPU driver selection via `videoDriver` (nvidia/amdgpu/intel/nvk) - CRITICAL for boot
- 4 hosts sharing modules with host-specific `variables.nix`
- 46 dev-shell templates: `nix flake init -t .#{template}`
- Python dev-shell includes hindsight-mcp (FastMCP server wrapping Hindsight REST API)
- Theme self-contained modules: GTK, icons, Kvantum, cursor, dconf in one file
- `home-manager.sharedModules` used by program modules to inject into all HM users

## COMMANDS
```bash
nix fmt                    # Format all Nix files (nixfmt-tree)
nix flake check            # Validate flake config
nix flake update           # Update all flake inputs
rebuild                    # Enhanced rebuild: username sync + hardware detection
rollback                   # System rollback utility
nix develop -t .#python    # Enter Python dev shell
nix develop -t .#<lang>    # Enter any of 46 language dev shells
```

## GIT TOPOLOGY

### Remotes
| Remote | URL | Role | Default Branch |
|--------|-----|------|----------------|
| `origin` | `git@github.com:storytyler/NixOS.git` | Private repo / primary backup | `main` |
| `fork` | `git@github.com:storytyler/NixOS-Downstream.git` | Collaboration fork (Sly-Harvey upstream) | `my-config` |
| `upstream` | `https://github.com/sly-harvey/NixOS.git` | Original upstream (read-only reference) | `master` |

### Workflow
1. **Develop** on local `main` branch
2. **Commit** with conventional prefixes: `FIX:`, `CHANGE:`, `FEAT:`, `REFACTOR:`, `DOCS:`
3. **Push to origin** (`git push origin main`) — private backup after each commit batch
4. **Build & test** manually via `rebuild` (NEVER from agent sessions — see codemem #93)
5. **Push to fork** (`git push fork main:my-config`) — only after verified working state
6. **Sync upstream** (`git fetch upstream`) — pull Sly-Harvey's changes when needed

### Aliases
- `git push-all` — pushes to both origin and fork simultaneously (`!git push origin main && git push fork main:my-config`)
- Use `push-all` only when both targets should receive the same confirmed-working state

### Collaboration with Sly-Harvey
- Fork repo: `storytyler/NixOS-Downstream` → `sly-harvey/NixOS`
- Push completed features to `fork/my-config` for PR/discussion
- Upstream uses `master` branch (not `main`)
- Reference: github.com/Sly-Harvey/NixOS, Fufexan's dotfiles for canonical Hyprland patterns

### Anti-Patterns (GIT)
- DON'T push to fork until changes are verified working
- DON'T force-push to origin or fork
- DON'T run `rebuild` from agent sessions — user runs from terminal with sudo
- DON'T push to upstream directly — always go through fork PRs

## NOTES
- **KNOWN BUG**: `hosts/Default/configuration.nix` line 63 has inverted games logic (`vars.games == false` should be `== true`)
- **TIMEZONE BUG**: Default, Scout-02, Subrelay-01 use invalid `"Chicago/US"` (should be `"America/Chicago"`)
- `videoDriver` is CRITICAL - wrong value causes boot failure
- `rebuild` supports both `$HOME/NixOS` and `/etc/nixos` locations
- `modules/core/default.nix` exists but is unused — hosts import core modules individually
- Repo has artifacts that should be gitignored: `repomix-output.xml`, `.chunkhound/`, `.stfolder/`
- Subdirectory AGENTS.md: modules/{programs,core,scripts,desktop,desktop/hyprland,hardware}, dev-shells{,/python}
- Hyprland config is Lua-based (6 files in `modules/desktop/hyprland/lua/`), not hyprlang
- Bar selection via `variables.bar`: waybar, hyprpanel, noctalia-shell, caelestia-shell
- `modules/desktop/hyprland/variables.nix` generates `variables.lua` with Nix-interpolated store paths
