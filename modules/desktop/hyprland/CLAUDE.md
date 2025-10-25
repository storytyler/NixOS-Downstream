# Hyprland Configuration

This directory contains the Hyprland tiling Wayland compositor configuration, providing a highly customizable and performant desktop experience.

## Configuration Files

- **default.nix** - Main Hyprland module configuration
- **hyprland.conf** - Core Hyprland settings and keybindings
- **rules.conf** - Window rules and application-specific settings
- **startup.conf** - Autostart applications and initialization commands

## Key Features

### Tiling Management
- Dynamic tiling with manual tiling support
- Workspace management (default: 9 workspaces)
- Window splitting and resizing
- Master/stack layout options

### Keybind Categories
- **Super + [1-9]** - Switch to workspace
- **Super + Shift + [1-9]** - Move window to workspace
- **Super + Enter** - Launch terminal
- **Super + D** - Launch app launcher (rofi/wofi)
- **Super + Q** - Close focused window
- **Super + Arrow keys** - Window navigation and resizing

### Visual Effects
- Window animations and transitions
- Blur and transparency effects
- Dynamic window borders
- Shadow effects

## Configuration Variables

The Hyprland module reads from `hosts/Default/variables.nix`:
- `terminal` - Default terminal application
- `browser` - Default web browser
- `editor` - Default text editor
- Theme and appearance settings

## Customization

### Adding Keybindings
Edit `hyprland.conf` to add new keybindings following the pattern:
```
bind = SUPER MODIFIER, KEY, ACTION
```

### Window Rules
Add application-specific window behavior in `rules.conf`:
```
windowrule = float, title:^(Floating Window)$
windowrule = size 800 600, class:^(application)$
```

### Startup Applications
Add autostart applications in `startup.conf`:
```
exec-once = application_name
```

## Integration

### With Other Modules
- **Hardware modules** - GPU drivers for hardware acceleration
- **Theme modules** - GTK/Qt themes, wallpapers, cursors
- **Program modules** - Terminal, browser, and application configurations

### Wayland Features
- Proper Wayland protocol support
- Screen sharing and remote desktop
- Touchpad and gesture support
- Multi-monitor support

## Dependencies

Required packages and modules:
- `hyprland` package
- Wayland components
- Display manager (SDDM recommended)
- Terminal emulator from variables
- Notification daemon
- Clipboard manager

## Troubleshooting

### Common Issues
1. **Windows not tiling properly** - Check window rules and floating settings
2. **Keybindings not working** - Verify syntax and conflicting binds
3. **Performance issues** - Check GPU drivers and disable heavy effects
4. **Application compatibility** - Some X11 apps may need XWayland

### Debug Commands
- `hyprctl clients` - List active windows
- `hyprctl workspaces` - Show workspace information
- `hyprctl monitors` - Display monitor configuration
- `hyprctl keyword <option>` - Check current settings

## Performance Optimization

### Recommended Settings
- Enable hardware acceleration
- Configure proper GPU drivers
- Optimize animation settings
- Use appropriate scaling for high DPI displays

### Resource Management
- Monitor CPU and memory usage
- Adjust worker threads if needed
- Optimize composite settings

## Testing Changes

After modifying Hyprland configuration:
1. Reload config: `hyprctl reload`
2. Or rebuild: `sudo nixos-rebuild switch --flake ".#Default"`
3. Restart Hyprland session for major changes

## Further Customization

### Additional Plugins
Hyprland supports plugins for extended functionality. Add them through the NixOS configuration if needed.

### Theming
Integrate with theme modules for consistent appearance across GTK, Qt, and Hyprland itself.