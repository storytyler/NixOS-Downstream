# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### System Configuration
- `rebuild` - **Primary method**: Custom wrapper script that automatically updates username in variables.nix, syncs hardware configuration, and applies changes
- `sudo nixos-rebuild switch --flake ".#Default"` - Standard NixOS rebuild command
- `sudo nixos-rebuild boot --flake ".#Default"` - Build configuration for next boot only
- `sudo nixos-rebuild test --flake ".#Default"` - Test configuration without switching
- `nh os switch --hostname Default` - Alternative rebuild using nh helper
- `nh os boot --hostname Default` - Alternative boot configuration using nh

### Installation & Maintenance
- `./install.sh` - Main installation script (detects live vs installed environment)
- `./live-install.sh` - Interactive installer for live environment
- `list-gens` - List available system generations
- `rollback N` - Rollback to generation N
- `sudo nix-collect-garbage -d` - Remove old generations

### Development
- `nix fmt` - Format all Nix files using nixfmt-tree (configured in flake.nix)
- `nix flake check` - Validate flake configuration and check for issues
- `nix flake update` - Update all flake inputs
- `nix develop` - Enter development shell (requires flake.nix with devShell)
- Development templates: `nix flake init -t .#template-name` (25+ templates available)

### Package Development Tools
- `nix-init` - Tool for creating new Nix packages from source URLs automatically
- `nurl` - Utility for generating Nix fetcher expressions from URLs
- `nix-prefetch-scripts` - Tools for finding hashes/revisions of Nix packages

## Architecture Overview

This is a sophisticated, modular NixOS configuration using flakes with a **variables-driven architecture** that enables maintainable, flexible system management across multiple hosts.

### Core Configuration Structure
- `flake.nix` - Main flake definition with inputs, outputs, and host configurations
- `modules/default.nix` - Module orchestrator that conditionally imports features based on variables
- `modules/core/` - Essential system modules (boot, networking, users, security, AI tools)
- `hosts/Default/variables.nix` - **Central configuration hub** that drives module selection
- `modules/scripts/` - Custom utility scripts including the enhanced rebuild system

### Variables-Driven Design Pattern
The entire system is controlled by variables in `hosts/Default/variables.nix`:

```nix
{
  username = "player00";         # Auto-updated by rebuild script
  desktop = "hyprland";          # Window manager choice
  terminal = "alacritty";        # Terminal emulator
  editor = "vscode";             # Development editor
  browser = "browseros";         # Browser configuration
  videoDriver = "intel";         # GPU driver (CRITICAL - must match hardware)
  games = false;                # Gaming module enablement flag
  hostname = "Station-00";       # System hostname
  # ... additional configuration options
}
```

### Conditional Module Loading System
Both `modules/default.nix` and `hosts/Default/configuration.nix` use intelligent module importing:

```nix
./hardware/video/${vars.videoDriver}.nix    # Auto-select GPU drivers
./desktop/${vars.desktop}                   # Load chosen desktop environment
./programs/browser/${vars.browser}          # Configure selected browser
./programs/terminal/${vars.terminal}        # Setup terminal environment
./programs/editor/${vars.editor}            # Configure development editor
```

### Module Categories
- **Core modules** (`modules/core/`): Base system functionality including nh CLI tool, syncthing, security, services, and AI orchestration tools (code-machine, model-runner)
- **Hardware modules** (`modules/hardware/`): GPU drivers (nvidia/amdgpu/intel), storage configurations, peripheral support
- **Desktop modules** (`modules/desktop/`): Window managers (Hyprland, i3-gaps, GNOME, Plasma6) with full configuration
- **Program modules** (`modules/programs/`): Application configurations organized by category:
  - `browser/` - Firefox, Floorp, Zen, BrowserOS configurations
  - `terminal/` - Kitty, Alacritty with full theming
  - `editor/` - NixVim, VSCode, Helix, Doom Emacs, NvChad configurations
  - `cli/` - Yazi, lf, tmux, direnv, lazygit, and development tools
  - `media/` - Discord, Spicetify, YouTube Music, OBS Studio, etc.
- **Theme modules** (`modules/themes/`): Visual appearance, wallpapers, comprehensive theming
- **Scripts** (`modules/scripts/`): Custom system utilities and automation tools

### Multi-Host Architecture
The system supports multiple hosts with the `mkHost` function:
- **Current hosts**: Default, Subrelay-01, Scout-02
- Each host has independent: variables, hardware configuration, package selections
- Host-specific configurations in `hosts/[hostname]/` directories
- Easy host addition via flake.nix configuration

### Key Flake Inputs
- `nixpkgs` (unstable) - Main package set
- `nixpkgs-stable` - Stable channel for specific packages
- `home-manager` - User environment management
- `nix-index-database` - Command-not-found functionality
- Editor configurations: `nixvim`, `doom-emacs`, `nvchad4nix`
- Desktop environments: `plasma-manager`
- Application integrations: `spicetify-nix`, `zen-browser`, `nix-flatpak`
- Development tools: `compose2nix`, `claude-code`

### Enhanced Rebuild System
The custom `rebuild` script (from `modules/scripts/rebuild.nix`) provides:
- **Automatic flake detection**: Works from both `$HOME/NixOS` and `/etc/nixos`
- **Username synchronization**: Automatically updates username in variables.nix to match current user
- **Hardware configuration sync**: Updates hardware-configuration.nix from `/etc/nixos/`
- **Git integration**: Auto-stages hardware configuration changes
- **Colored output** and error handling
- **Safety checks**: Prevents execution as root

### Development Environment System
25+ pre-configured development shell templates including:
- **Languages**: Python, Node.js, Rust, Go, Java, Haskell, C/C++, C#, Elixir
- **Tools**: Docker, Pulumi, Protocol Buffers, LaTeX, HashiCorp suite
- **Special**: Nix development, Shell scripts, Bun, Deno, various CLIs

Usage: `nix flake init -t .#template-name` then `nix develop`

### Package Management Workflow
- **nix-init**: Create Nix packages from source URLs automatically
- **nurl**: Generate Nix fetcher expressions from source URLs
- **Overlays system**: Custom package modifications in `/overlays/`
- **Host-specific packages**: Managed via `hosts/[hostname]/host-packages.nix`
- **Stable channel access**: Use packages from nixpkgs-stable when needed

### Custom AI/Development Tools
- **code-machine-cli**: CLI-native orchestration platform for AI-assisted code generation
- **model-runner**: Docker's Model Runner for AI model execution
- **claude-code**: Claude Code integration
- **gemini-cli**, **goose-cli**: Additional AI CLI tools

### Configuration Management Patterns
- **Modular package management**: Use appropriate `modules/programs/` modules for modular packages
- **Host-specific packages**: Add to `hosts/Default/host-packages.nix` for host-specific software
- **Testing**: Add directly to `configuration.nix` for temporary testing
- **Theme management**: Controlled by variables in `variables.nix` with automatic application

## Development Workflow

### Making Configuration Changes
1. Edit `hosts/Default/variables.nix` to change user preferences or system settings
2. Add packages to appropriate modules or host-packages.nix
3. Run `rebuild` to apply changes (preferred method)
4. System automatically handles username sync and hardware detection

### Adding New Modules
1. Create module file in appropriate `modules/` subdirectory
2. Import conditionally in `modules/default.nix` based on variables
3. Test by enabling relevant variables in `variables.nix`
4. Rebuild to apply changes

### Working with Development Shells
1. Initialize project: `nix flake init -t .#python` (or other template)
2. Enter development environment: `nix develop`
3. Work within the isolated development environment
4. Exit when done

### Package Development
1. Use `nurl <source-url>` to generate fetcher expression
2. Use `nix-init <source-url>` to create full package template
3. Refine package expression as needed
4. Add to appropriate configuration file or overlay

## Critical Configuration Points

### GPU Driver Configuration
The `videoDriver` variable in `variables.nix` is **critical** and must match your actual hardware:
- `nvidia` - For NVIDIA GPUs
- `amdgpu` - For AMD GPUs
- `intel` - For Intel GPUs
- Incorrect settings will cause display/boot issues

### System Recovery
- Access bootloader menu to select previous generation if boot fails
- Use `rollback N` command from working system to revert changes
- Test configurations with `sudo nixos-rebuild test` before applying

### Host Management
- Each host requires separate entry in `flake.nix`
- Copy existing host directory structure for new hosts
- Update variables.nix for host-specific settings
- Use hostname-specific rebuild commands: `rebuild` (uses current host) or `sudo nixos-rebuild switch --flake ".#Hostname"`