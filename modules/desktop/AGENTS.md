# Desktop Environment Modules

Desktop environment and window manager configurations.

## STRUCTURE
```
modules/desktop/
├── gnome/       # GNOME desktop environment
├── hyprland/    # Hyprland tiling Wayland compositor (highly configurable)
├── i3-gaps/     # i3-gaps tiling X11 window manager
└── plasma6/     # KDE Plasma 6 desktop environment
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Switch desktop | `hosts/Default/variables.nix` → set `desktop` | Options: hyprland, i3-gaps, gnome, plasma6 |
| Configure Hyprland | `modules/desktop/hyprland/` | Wayland compositor, workspaces, rules, theming |
| Configure GNOME | `modules/desktop/gnome/` | Uses gsettings, simpler configuration |
| Configure Plasma | `modules/desktop/plasma6/` | Uses plasma-manager for declarative config |

## CONVENTIONS
- Desktop selected via `variables.desktop` variable in `variables.nix`
- Conditional import: `./desktop/${vars.desktop}` in `modules/default.nix`
- Each desktop handles its own autostart, session, window rules

## ANTI-PATTERNS
- DON'T hardcode desktop-specific values in shared modules - use variables
- DON'T mix desktop configurations across different environments
