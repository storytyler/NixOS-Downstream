# Hyprland Desktop Configuration

Hyprland Wayland tiling compositor with full ecosystem of sub-programs. The most complex desktop module.

## STRUCTURE
```
hyprland/
├── default.nix           # Main compositor config (110 lines): Hyprland 0.55.0, portal, polkit agent
├── variables.nix         # Generates variables.lua with Nix-interpolated store paths
├── lua/                  # Hyprland Lua config (NOT hyprlang)
│   ├── hyprland.lua      # Entrypoint: requires all other Lua modules
│   ├── settings.lua      # Env vars, exec-once, input/general/decoration/render/misc/dwindle/master config
│   ├── binds.lua         # All keybinds via hl.bind(), workspace 1-10 loop
│   ├── animations.lua    # Bezier curves + animation definitions
│   ├── monitors.lua      # Monitor layout + workspace rules (host-specific)
│   └── rules.lua         # Window rules (PiP float/pin, games tag)
├── programs/
│   ├── waybar/           # Status bar (3 files: default.nix, stylish.nix, minimal.nix)
│   ├── hyprpanel/        # Hyprpanel bar
│   ├── noctalia-shell/   # Noctalia shell bar
│   ├── caelestia-shell/  # Caelestia shell bar
│   ├── rofi/             # App launcher (drun, window, emoji, wallpaper modes)
│   │   ├── config.nix    # Rofi theme/style configuration
│   │   ├── colors/       # Color scheme files
│   │   ├── assets/       # Icons and images
│   │   └── launchers/    # 7 launcher type variants (type-1 through type-7)
│   ├── hyprlock/         # Screen lock (uses hyprlockWallpaper from variables)
│   ├── hypridle/         # Idle manager (screen off, lock, suspend timeouts)
│   ├── swaync/           # Notification daemon (excluded when bar = hyprpanel)
│   └── wlogout/          # Logout/power menu
├── scripts/
│   ├── wallpaper.nix     # Wallpaper setter derivation (SUPER+SHIFT+W)
│   ├── autoclicker.nix   # Auto-clicker script derivation
│   └── *.nix             # 18 Nix-wrapped utility scripts (gpuinfo, volumecontrol, etc.)
└── icons/                # Notification/system icons (25+ files)
    └── notifications/vol/# Volume notification icons
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Keybinds | `lua/binds.lua` | SUPER+key bindings via `hl.bind()`, workspace rules |
| Window rules | `lua/rules.lua` | Float, size, workspace assignments per app |
| Animations | `lua/animations.lua` | Transition curves and durations |
| Monitor layout | `lua/monitors.lua` | Monitor positions, workspace assignments (host-specific) |
| Environment/exec | `lua/settings.lua` | Env vars, exec-once, input, decoration, render config |
| Lua variables | `variables.nix` | Generates `variables.lua` with Nix store paths for scripts |
| Status bar | `programs/waybar/` | 3 files: default.nix + stylish.nix + minimal.nix (selected via `waybarTheme`) |
| Bar selection | `hosts/{host}/variables.nix` → `bar` | Options: waybar, hyprpanel, noctalia-shell, caelestia-shell |
| App launcher | `programs/rofi/` | 7 launcher styles, emoji mode, wallpaper selector |
| Lock screen | `programs/hyprlock/` | Uses `variables.hyprlockWallpaper` |
| Idle timeouts | `programs/hypridle/` | Screen dim → lock → suspend sequence |
| Change wallpaper | SUPER+SHIFT+W | Rofi wallpaper picker using `modules/themes/wallpapers/` |

## CONVENTIONS
- **Lua-based config**: Hyprland 0.55.0 from flake input (not nixpkgs). Uses `require()` to load modules.
- No `wayland.windowManager.hyprland` — Lua files deployed via `xdg.configFile`
- `variables.nix` generates `variables.lua` with Nix-interpolated store paths for all scripts and binaries
- Bar is variable-driven: `imports = [ ./programs/${bar} ]` in default.nix
- swaync excluded when bar = hyprpanel: `++ optional (bar != "hyprpanel") ./programs/swaync`
- All sub-programs configured as Nix modules with inline configs
- Theme imported at desktop level: `imports = [ ../../themes/Catppuccin ]`
- HM lambda for variables.nix uses `{ config, ... }:` (safe — accesses HM config for xdg path)
- HM lambda for default.nix uses `_:` (avoids shadowing NixOS `config`)

## ANTI-PATTERNS
- DON'T use `wayland.windowManager.hyprland` — raw Lua files via `xdg.configFile` instead
- DON'T add wallpaper files outside `modules/themes/wallpapers/`
- DON'T mix Hyprland-specific configs with gnome configs
- DON'T use `_:` in variables.nix HM lambda — it needs `{ config, ... }:` for xdg path
- DON'T use `{ config, ... }:` in default.nix HM lambda — `config` gets shadowed
- DON'T hardcode monitor layouts in `monitors.lua` — needs per-host parameterization
