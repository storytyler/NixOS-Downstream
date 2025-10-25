# NixOS Configuration

A modular NixOS configuration using flakes with a variables-driven architecture for flexible system management.

## Table of Contents

- [Quick Start](#quick-start)
- [System Architecture](#system-architecture)
- [Configuration Management](#configuration-management)
- [Host Management](#host-management)
- [Development Workflow](#development-workflow)
- [Common Tasks](#common-tasks)

## Quick Start

### Installation
```bash
git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
cd ~/NixOS
./install.sh
```

### First Configuration
Edit `hosts/Default/variables.nix` to match your system:
- Set `videoDriver` to your GPU (nvidia, amdgpu, intel)
- Configure user preferences (desktop, terminal, editor, browser)
- Adjust localization settings

### Apply Configuration
```bash
rebuild  # Custom script that handles username sync and hardware detection
```

## System Architecture

### Variables-Driven Design
The system uses `hosts/Default/variables.nix` as the central configuration hub:

```nix
{
  username = "player00";      # Auto-updated by rebuild script
  desktop = "hyprland";       # hyprland, i3-gaps, gnome, plasma6
  terminal = "kitty";         # kitty, alacritty
  editor = "vscode";          # nixvim, vscode, helix, doom-emacs, nvchad
  browser = "zen";            # firefox, floorp, zen
  videoDriver = "intel";      # nvidia, amdgpu, intel (CRITICAL)
  games = false;              # Enable gaming module
}
```

### Module Structure
```
modules/
├── core/           # Essential system (boot, networking, security)
├── hardware/       # GPU drivers, storage configuration
├── desktop/        # Window managers and desktop environments
├── programs/       # Applications organized by category
│   ├── browser/    # Web browsers
│   ├── terminal/   # Terminal emulators
│   ├── editor/     # Development editors
│   ├── cli/        # Command-line tools
│   └── media/      # Media applications
├── themes/         # Visual themes and wallpapers
└── scripts/        # Custom system utilities
```

### Conditional Module Loading
`modules/default.nix` automatically imports modules based on variables:

```nix
./hardware/video/${vars.videoDriver}.nix    # GPU drivers
./desktop/${vars.desktop}                   # Desktop environment
./programs/browser/${vars.browser}          # Browser configuration
./programs/terminal/${vars.terminal}        # Terminal setup
./programs/editor/${vars.editor}            # Editor configuration
```

## Configuration Management

### Rebuilding System
```bash
# Primary method (recommended)
rebuild                              # Auto-updates username and hardware config

# Alternative methods
sudo nixos-rebuild switch --flake ".#Default"
nh os switch --hostname Default

# Test without applying
sudo nixos-rebuild test --flake ".#Default"

# Build for next boot only
sudo nixos-rebuild boot --flake ".#Default"
```

### Configuration Files
- `hosts/Default/variables.nix` - Central configuration variables
- `hosts/Default/configuration.nix` - Module imports and system settings
- `hosts/Default/hardware-configuration.nix` - Auto-generated hardware config
- `hosts/Default/host-packages.nix` - Host-specific packages

### Custom Scripts
Located in `modules/scripts/`:
- `rebuild` - Enhanced rebuild with username sync and hardware detection
- `rollback` - System rollback utility
- `tmux-sessionizer` - Tmux session management
- `extract` - Universal archive extraction

## Host Management

### Adding New Hosts
1. Copy existing host:
   ```bash
   cp -r hosts/Default hosts/NewHost
   ```

2. Edit `hosts/NewHost/variables.nix` for host-specific settings

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations = {
     Default = mkHost "Default";
     NewHost = mkHost "NewHost";
   };
   ```

4. Rebuild with new host:
   ```bash
   sudo nixos-rebuild switch --flake ".#NewHost"
   ```

### Host-Specific Configuration
Each host can have:
- Unique hardware configuration
- Different user preferences
- Separate package selections
- Custom module imports

## Development Workflow

### Code Formatting
```bash
nix fmt  # Format all Nix files using nixfmt-tree
```

### Flake Management
```bash
nix flake check        # Validate flake configuration
nix flake update       # Update all inputs
```

### Development Shells
Create projects with templates:
```bash
nix flake init -t .#python    # Python development environment
nix flake init -t .#node      # Node.js development environment

cd new-project
nix develop                  # Enter development shell
```

## Common Tasks

### Changing Desktop Environment
1. Edit `hosts/Default/variables.nix`:
   ```nix
   desktop = "gnome";  # Change from hyprland to gnome
   ```

2. Rebuild:
   ```bash
   rebuild
   ```

3. Reboot for full effect

### Updating GPU Drivers
1. Update `variables.nix`:
   ```nix
   videoDriver = "nvidia";  # Change to match your GPU
   ```

2. Rebuild system

### Adding Packages
- For modular packages: Add to appropriate `modules/programs/` module
- For host-specific: Add to `hosts/Default/host-packages.nix`
- For testing: Add directly to `configuration.nix`

### System Rollback
```bash
list-gens      # List available system generations
rollback 42    # Rollback to generation 42
```

### Theme Configuration
Themes are controlled by variables and automatically applied:
- Edit `theme` and `themeVariant` in `variables.nix`
- Add custom themes to `modules/themes/`
- Rebuild to apply changes

## System Maintenance

### Regular Updates
```bash
nix flake update          # Update flake inputs
rebuild                   # Apply updates
```

### Cleanup
```bash
sudo nix-collect-garbage -d    # Remove old generations
```

### Debugging
- Check system logs: `journalctl -xe`
- Test configuration: `sudo nixos-rebuild test`
- Monitor resources: `btop` (included in CLI tools)

## Troubleshooting

### Build Failures
1. Check syntax in modified files
2. Verify variable names and values
3. Review error messages for specific issues

### Boot Issues
- Use bootloader menu to select previous generation
- Run `rollback` from working system

### Hardware Problems
1. Verify `videoDriver` setting matches actual hardware
2. Check `hardware-configuration.nix` matches system
3. Regenerate hardware config if needed

### Performance Issues
- Monitor with `btop`
- Review enabled modules and packages
- Check for hardware acceleration issues

## Key Features

- **Modular Design**: Only load needed components
- **Variables-Driven**: Single file controls most configuration
- **Automatic Detection**: Hardware and user detection
- **Rollback Support**: Easy system recovery
- **Multiple Hosts**: Support for different machines
- **Development Ready**: Built-in development environments