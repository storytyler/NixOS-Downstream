# Desktop Modules

This directory contains desktop environment and window manager configurations for different user interfaces.

## Available Desktop Environments

- **gnome/** - GNOME desktop environment configuration
- **hyprland/** - Hyprland tiling Wayland compositor (highly configurable)
- **i3-gaps/** - i3-gaps tiling X11 window manager
- **plasma6/** - KDE Plasma 6 desktop environment

## Module Selection

The desktop environment is selected based on `variables.desktop` in `hosts/Default/variables.nix`:

```nix
# Example variable setting
desktop = "hyprland";  # Options: "gnome", "hyprland", "i3-gaps", "plasma6"
```

## Working with Desktop Modules

### Switching Desktop Environments
1. Edit `hosts/Default/variables.nix` and change the `desktop` variable
2. Rebuild: `sudo nixos-rebuild switch --flake ".#Default"`
3. Reboot or restart display manager

### Configuring Specific Desktops

#### Hyprland
- Located in `hyprland/` directory
- Contains configuration files, keybindings, and rules
- Supports workspaces, window management, and theming
- See `hyprland/CLAUDE.md` for detailed configuration

#### GNOME
- Located in `gnome/` directory
- Uses GNOME settings and extensions
- Simpler configuration through gsettings

#### i3-gaps
- Located in `i3-gaps/` directory
- Traditional tiling window manager
- Configurable through i3 config files

#### Plasma6
- Located in `plasma6/` directory
- Uses plasma-manager for declarative configuration
- Rich desktop environment with many customization options

## Common Desktop Configuration

### Display Manager
All desktop modules use a compatible display manager (typically SDDM or GDM) configured in core modules.

### Environment Variables
Desktop modules may set:
- `XDG_` variables for proper desktop integration
- GTK/Qt theme settings
- Cursor and icon themes
- Wayland/X11 specific settings

### Session Management
Each desktop module handles:
- Autostart applications
- Session initialization
- Window placement rules
- Desktop settings persistence

## Dependencies

Desktop modules depend on:
- Core modules for base system functionality
- Hardware modules for GPU drivers
- Theme modules for visual appearance
- Program modules for desktop applications

## Adding New Desktop Environments

1. Create a new directory for the desktop environment
2. Add configuration files following the existing pattern
3. Update `modules/default.nix` to include the new option
4. Add conditional imports based on the desktop variable
5. Update documentation

## Troubleshooting

### Desktop Not Starting
1. Check GPU drivers in hardware modules
2. Verify display manager configuration
3. Check system logs: `journalctl -xe`
4. Ensure proper variable selection

### Performance Issues
1. Verify hardware acceleration is working
2. Check for conflicting configurations
3. Review desktop-specific settings
4. Consider enabling/disabling compositors

## Testing Changes

After modifying desktop configurations:
1. Test: `sudo nixos-rebuild test --flake ".#Default"`
2. Switch: `sudo nixos-rebuild switch --flake ".#Default"`
3. Restart display manager or reboot for full effect