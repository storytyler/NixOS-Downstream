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

### Installation
- `./install.sh` - Main installation script (detects live vs installed environment)
- `./live-install.sh` - Interactive installer for live environment

### Development
- `nix fmt` - Format Nix files (uses nixfmt-tree, configured in flake.nix)
- `nix flake check` - Check flake configuration
- `nix flake update` - Update flake inputs
- Development shells available in `dev-shells/` directory for various languages

## Architecture Overview

This is a modular NixOS configuration using flakes with a variables-driven architecture:

### Core Configuration
- `flake.nix` - Main flake definition with inputs and outputs, defines formatter and templates
- `modules/default.nix` - Module orchestrator that conditionally imports features based on variables
- `modules/core/` - Essential system modules (boot, networking, users, security, etc.)
- `hosts/Default/variables.nix` - Host-specific configuration variables that drive module selection
- `modules/scripts/` - Custom utility scripts including rebuild.nix

### Module Categories
- **Core modules** (`modules/core/`): Base system functionality including nh, syncthing, security, services
- **Hardware modules** (`modules/hardware/`): GPU drivers (nvidia/amdgpu/intel), storage, peripheral support
- **Desktop modules** (`modules/desktop/`): Window managers (Hyprland, i3-gaps, GNOME, Plasma6)
- **Program modules** (`modules/programs/`): Organized by category:
  - `browser/` - Firefox, Floorp, Zen configurations
  - `terminal/` - Kitty, Alacritty
  - `editor/` - NixVim, VSCode, Helix, Doom Emacs, NvChad
  - `cli/` - Yazi, lf, tmux, direnv, lazygit, etc.
  - `media/` - Discord, Spicetify, YouTube Music, OBS Studio, etc.
- **Theme modules** (`modules/themes/`): Visual appearance, wallpapers, theming
- **Scripts** (`modules/scripts/`): Custom system utilities and rebuild scripts

### Configuration Pattern
The system uses a variables-driven approach where `hosts/Default/variables.nix` defines:
- User preferences (desktop, terminal, editor, browser, file manager)
- Hardware configuration (GPU driver, hostname)
- Localization settings (timezone, locale, keyboard layout)
- Feature flags (gaming support, shell choice)

These variables control which modules are imported in both `modules/default.nix` and `hosts/Default/configuration.nix`, enabling a highly modular and maintainable configuration with conditional imports.

### Key Inputs
- `nixpkgs` (unstable) - Main NixOS package set
- `nixpkgs-stable` - Stable package set for specific packages
- `home-manager` - User environment management
- `nix-index-database` - Nix database for command-not-found
- `nixvim`, `doom-emacs`, `nvchad4nix` - Editor configurations
- `plasma-manager` - KDE Plasma module system
- `spicetify-nix` - Spotify theming
- `zen-browser` - Browser configuration
- `nix-flatpak` - Flatpak integration
- `nur` - Nix User Repository

### Host Configuration
The system defines a single host "Default" but is structured to easily support multiple hosts. Each host would have its own:
- `configuration.nix` - Host-specific system configuration with module imports
- `variables.nix` - Host preference variables that drive the configuration
- `hardware-configuration.nix` - Hardware-specific settings
- `host-packages.nix` - Host-specific package selections

### Custom Utilities
- `rebuild` script (from `modules/scripts/rebuild.nix`) automatically:
  - Detects flake location ($HOME/NixOS or /etc/nixos)
  - Updates username in variables.nix to match current user
  - Syncs hardware configuration from /etc/nixos/
  - Provides colored output and error handling