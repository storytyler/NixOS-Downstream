# Desktop Environment Modules

Desktop environment and window manager configurations. 3 options available.

## STRUCTURE
```
modules/desktop/
├── hyprland/    # Hyprland Wayland tiling compositor (most complex, 13+ files)
│   ├── programs/   # waybar, rofi, hyprlock, hypridle, swaync, wlogout, dunst
│   ├── scripts/    # wallpaper setter, autoclicker
│   └── icons/      # notification icons
├── i3-gaps/     # i3-gaps X11 tiling WM (polybar, picom, dunst)
└── gnome/       # GNOME desktop (dconf/gsettings)
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Switch desktop | `hosts/{host}/variables.nix` → set `desktop` | Options: hyprland, i3-gaps, gnome |
| Hyprland config | `hyprland/default.nix` | 595 lines: keybinds, env, animations, window rules |
| Waybar status bar | `hyprland/programs/waybar/` | 750 lines with inline Catppuccin CSS |
| Rofi launcher | `hyprland/programs/rofi/` | drun, window, emoji, wallpaper modes |
| GNOME config | `gnome/default.nix` + `dconf.nix` | Extensions, package exclusions |
| i3-gaps config | `i3-gaps/default.nix` | polybar, picom, workspace bindings |

## CONVENTIONS
- Desktop selected via `variables.desktop` variable in `variables.nix`
- Conditional import: `./desktop/${vars.desktop}` in `modules/default.nix`
- Each desktop imports its own theme: `imports = [ ../../themes/Catppuccin ]`
- GNOME uses `lib.mkForce false` to disable TLP (its own power mgmt)
- See `hyprland/AGENTS.md` for detailed Hyprland sub-program docs

## ANTI-PATTERNS
- DON'T hardcode desktop-specific values in shared modules - use variables
- DON'T mix desktop configurations across different environments
