# Core Modules

This directory contains essential system modules that provide base functionality for the NixOS configuration.

## Module Structure

Each module in this directory handles a fundamental aspect of the system:

- **boot.nix** - System boot configuration, bootloader settings
- **networking.nix** - Network configuration, firewall, DNS settings
- **nh.nix** - NixHelper tool for improved NixOS management
- **security.nix** - Security settings, user permissions, sudo configuration
- **services.nix** - Core system services (logging, time sync, etc.)
- **syncthing.nix** - File synchronization service
- **system.nix** - Basic system settings (locale, timezone, etc.)
- **users.nix** - User account management and groups

## Working with Core Modules

### Adding New Core Functionality
1. Create a new `.nix` file for the functionality
2. Follow the existing module pattern with proper NixOS module structure
3. Import the module in `modules/default.nix` if it should be conditionally enabled
4. Or add it to the base imports if it's always required

### Module Pattern
Each module should:
- Accept proper inputs and configuration options
- Be self-contained and idempotent
- Include clear documentation comments
- Follow NixOS module conventions

### Variables Integration
Core modules typically read from `variables.nix` for:
- Hostname settings
- User configuration
- Locale and timezone
- Network settings
- Security preferences

## Common Tasks

### Modifying System Settings
Edit the relevant module file or update `hosts/Default/variables.nix` for values that should be configurable.

### Adding New Services
1. Create the service configuration in the appropriate module
2. Use `services.<name>.enable = true;` pattern
3. Make it conditional on variables if needed

### Security Adjustments
Edit `security.nix` for:
- Sudo configuration
- User permissions
- System security policies
- Firewall rules

## Dependencies

Core modules may depend on:
- `hosts/Default/variables.nix` for configuration values
- Each other for related functionality
- NixOS options and packages

## Testing Changes

After modifying core modules:
1. Test configuration: `sudo nixos-rebuild test --flake ".#Default"`
2. Apply changes: `sudo nixos-rebuild switch --flake ".#Default"`
3. Or use the custom script: `./rebuild`