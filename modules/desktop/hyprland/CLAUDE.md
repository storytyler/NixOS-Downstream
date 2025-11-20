# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### System Configuration
- `sudo nixos-rebuild switch --flake ".#Default"` - Apply configuration changes and switch to new system
- `sudo nixos-rebuild boot --flake ".#Default"` - Build configuration for next boot
- `sudo nixos-rebuild test --flake ".#Default"` - Test configuration without switching
- `nh os switch` - Alternative rebuild command using nh helper
- `nh os boot` - Alternative boot configuration using nh
- `rebuild` - Custom wrapper script that automatically updates username and syncs hardware configuration

### Development
- `nix fmt` - Format Nix files (uses nixfmt-tree, configured in flake.nix)
- `nix flake check` - Check flake configuration
- `nix flake update` - Update flake inputs

## Architecture Overview

This is the Hyprland module within a larger modular NixOS configuration using flakes with a variables-driven architecture.

### Module Structure

#### Core Configuration
- `default.nix` - Main Hyprland module configuration with imports and settings
- Imports from `programs/` subdirectories for individual application configurations
- Inherits variables from host configuration (browser, terminal, keyboard layout, etc.)

#### Program Configurations (`programs/`)
- **waybar/** - Highly configurable status bar with Cava audio visualizer, custom modules, and Catppuccin theming
- **rofi/** - Application launcher with multiple style themes (6 types, 15+ styles) and color schemes
- **hyprlock/** - Screen locking utility with configuration
- **hypridle/** - Idle management daemon
- **swaync/** - Notification center
- **wlogout/** - Logout menu
- **dunst/** - Notification daemon (currently commented out)

#### Scripts (`scripts/`)
- **wallpaper.nix** - Wallpaper management with swww integration
- **autoclicker.nix** - Auto-clicker utility for gaming/accessibility
- **Utility scripts** - Various shell scripts for system functions:
  - `keybinds.sh` - Display keybinding help
  - `screenshot.sh` & `screen-record.sh` - Screen capture tools
  - `keyboardswitch.sh` - Keyboard layout switching
  - `gamemode.sh` - Toggle gaming performance mode
  - `gpuinfo.sh` - GPU information display
  - `brightnesscontrol.sh` & `volumecontrol.sh` - System controls
  - `batterynotify.sh` - Battery notifications
  - `ClipManager.sh` - Clipboard management
  - `MediaCtrl.sh` - Media controls
  - And various other utility scripts

### Key Features

#### Hyprland Configuration
- **Variables-driven**: Inherits settings from host variables (terminal, browser, keyboard, wallpaper)
- **Wayland-optimized**: Comprehensive Wayland environment variable configuration
- **Multi-monitor support**: Pre-configured monitor workspaces and arrangements
- **Gaming integration**: Game-specific window rules, performance optimizations, and Steam support
- **Extensive keybindings**: Comprehensive keybinding system with modifiers, workspace management, and application launching

#### Visual Design
- **Catppuccin theming**: Integrated Catppuccin color scheme throughout
- **Blur and transparency**: Configured blur effects for specific applications
- **Window rules**: Extensive opacity, floating, and behavioral rules for applications
- **Custom aesthetics**: Rounded corners, gaps, borders with gradient colors

#### System Integration
- **Clipboard management**: wl-clipboard with cliphist for persistent clipboard history
- **Screenshot tools**: grimblast, slurp, swappy for screen capture
- **Audio controls**: pamixer, pavucontrol integration
- **Network management**: NetworkManager applet integration
- **Authentication**: hyprpolkitagent for system authentication

### Configuration Pattern

The Hyprland module follows the parent architecture's variables-driven approach:

1. **Variable inheritance**: Pulls configuration from `../../../hosts/${host}/variables.nix`
2. **Conditional imports**: Based on available programs and user preferences
3. **Modular design**: Each program has its own configuration module
4. **Home-manager integration**: Uses sharedModules for user-space configuration

### Dependencies

- **Themes**: Catppuccin theme module (`../../themes/Catppuccin`)
- **Hardware**: Proper GPU driver configuration required
- **Packages**: Extensive package list for Wayland-based workflow
- **Display manager**: Configures default session to Hyprland

### Customization Points

#### Key Variables
- `terminal` - Default terminal application
- `browser` - Default web browser
- `tuiFileManager` - Terminal file manager
- `kbdLayout` & `kbdVariant` - Keyboard configuration
- `defaultWallpaper` - Default wallpaper path
- `clock24h` - 24-hour time format preference

#### Configuration Areas
- **Workspaces**: 10 workspaces with monitor-specific assignments
- **Keybindings**: Extensive SUPER-based keybinding system
- **Window rules**: Application-specific behavior and appearance
- **Startup applications**: Configurable autostart applications
- **Environment variables**: Comprehensive Wayland optimization

### Performance Features

- **Variable refresh rate**: Configured for gaming and media
- **Direct scanout**: Hardware acceleration for games
- **Swallowing**: Terminal window swallowing for seamless workflow
- **Gaming mode**: Toggle script for performance optimization
- **GPU monitoring**: Real-time GPU information display

## Testing and Development

When modifying Hyprland configuration:

1. **Test configuration**: `sudo nixos-rebuild test --flake ".#Default"`
2. **Apply changes**: `sudo nixos-rebuild switch --flake ".#Default"`
3. **Restart Hyprland**: Super + Backspace to restart, or logout/login
4. **Check logs**: `journalctl -xe` for debugging
5. **Validate config**: Use Hyprland's built-in configuration validation

The module is designed to be modular while maintaining tight integration with the larger NixOS configuration system.