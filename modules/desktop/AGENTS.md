# Desktop Environment Modules

Desktop environment and window manager configurations. 2 options available.

## STRUCTURE
```
modules/desktop/
├── hyprland/    # Hyprland Wayland tiling compositor (most complex module)
│   ├── lua/        # 6 Lua config files (hyprland, settings, binds, animations, monitors, rules)
│   ├── variables.nix  # Generates variables.lua with Nix-interpolated store paths
│   ├── programs/   # waybar, rofi, hyprlock, hypridle, swaync, wlogout, hyprpanel, noctalia-shell, caelestia-shell
│   ├── scripts/    # 18 Nix-wrapped utility scripts
│   └── icons/      # Notification/system icons
└── gnome/       # GNOME desktop (dconf/gsettings)
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Switch desktop | `hosts/{host}/variables.nix` → set `desktop` | Options: hyprland, gnome |
| Switch bar | `hosts/{host}/variables.nix` → set `bar` | Options: waybar, hyprpanel, noctalia-shell, caelestia-shell |
| Hyprland config | `hyprland/default.nix` | 110 lines: Lua-based config, Hyprland 0.55.0 from flake input |
| Hyprland Lua | `hyprland/lua/` | 6 files: hyprland, settings, binds, animations, monitors, rules |
| Hyprland vars | `hyprland/variables.nix` | Generates `variables.lua` with Nix store paths |
| Waybar status bar | `hyprland/programs/waybar/` | 3 files: default.nix, stylish.nix, minimal.nix |
| Bar programs | `hyprland/programs/${bar}/` | Selected via `variables.bar` |
| Rofi launcher | `hyprland/programs/rofi/` | drun, window, emoji, wallpaper modes |
| GNOME config | `gnome/default.nix` + `dconf.nix` | Extensions, package exclusions |

## CONVENTIONS
- Desktop selected via `variables.desktop` variable in `variables.nix`
- Bar selected via `variables.bar` variable (waybar/hyprpanel/noctalia-shell/caelestia-shell)
- Conditional import: `./desktop/${vars.desktop}` in `modules/default.nix`
- Hyprland imports bar via `./programs/${bar}` — bar is a variable-driven conditional import
- `swaync` (notification daemon) excluded when bar = hyprpanel (it has built-in notifications)
- Each desktop imports its own theme: `imports = [ ../../themes/Catppuccin ]`
- GNOME uses `lib.mkForce false` to disable TLP (its own power mgmt)
- Hyprland uses NO `wayland.windowManager.hyprland` — deploys raw Lua via `xdg.configFile`
- See `hyprland/AGENTS.md` for detailed Hyprland sub-program docs

## ANTI-PATTERNS
- DON'T hardcode desktop-specific values in shared modules - use variables
- DON'T mix desktop configurations across different environments
- DON'T use `wayland.windowManager.hyprland` — Lua files deployed directly via `xdg.configFile`
- DON'T use `{ config, ... }:` in `home-manager.sharedModules` lambdas for Hyprland — use `_:` to avoid shadowing
