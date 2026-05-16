# Hyprland Desktop Configuration

Hyprland Wayland tiling compositor with full ecosystem of sub-programs. The most complex desktop module (13+ config files).

## STRUCTURE
```
hyprland/
├── default.nix           # Main compositor config (595 lines): keybinds, env, animations, window rules
├── programs/
│   ├── waybar/           # Status bar (750 lines, inline Catppuccin CSS)
│   ├── rofi/             # App launcher (drun, window, emoji, wallpaper modes)
│   │   ├── config.nix    # Rofi theme/style configuration
│   │   ├── colors/       # Color scheme files
│   │   ├── assets/       # Icons and images
│   │   └── launchers/    # 7 launcher type variants (type-1 through type-7)
│   ├── hyprlock/         # Screen lock (uses hyprlockWallpaper from variables)
│   ├── hypridle/         # Idle manager (screen off, lock, suspend timeouts)
│   ├── swaync/           # Notification daemon
│   ├── swaylock/         # Alternative screen lock
│   ├── wlogout/          # Logout/power menu
│   └── dunst/            # Alternative notification daemon
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
| Keybinds | `default.nix` | SUPER+key bindings, workspace rules |
| Window rules | `default.nix` | Float, size, workspace assignments per app |
| Animations | `default.nix` | Transition curves and durations |
| Status bar | `programs/waybar/` | Modules: workspaces, clock, tray, network, battery |
| App launcher | `programs/rofi/` | 7 launcher styles, emoji mode, wallpaper selector |
| Lock screen | `programs/hyprlock/` | Uses `variables.hyprlockWallpaper` |
| Idle timeouts | `programs/hypridle/` | Screen dim → lock → suspend sequence |
| Change wallpaper | SUPER+SHIFT+W | Rofi wallpaper picker using `modules/themes/wallpapers/` |

## CONVENTIONS
- All sub-programs configured as Nix modules with inline configs (no external files except icons/assets)
- Waybar CSS is inline in the Nix file (Catppuccin Mocha theme hardcoded)
- Rofi launchers share common `shared/` directories for cross-type resources
- Wallpaper derived via `pkgs.writeShellScriptBin` using `swww` or `hyprpaper`
- Theme imported at desktop level: `imports = [ ../../themes/Catppuccin ]`

## ANTI-PATTERNS
- DON'T modify keybinds without checking `default.nix` — they're all in one 595-line file
- DON'T add wallpaper files outside `modules/themes/wallpapers/`
- DON'T mix Hyprland-specific configs with i3/gnome configs
- DON'T test sleep/suspend on NVIDIA without caution (known TODO in default.nix)
