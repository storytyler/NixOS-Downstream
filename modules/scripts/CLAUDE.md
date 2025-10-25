# System Scripts

This directory contains custom utility scripts that enhance system management and user productivity. These scripts are packaged and made available system-wide through the NixOS configuration.

## Available Scripts

### System Management
- **rebuild.nix** - Enhanced system rebuild script with automatic username updates and hardware sync
- **rollback.nix** - System rollback utility for quickly reverting to previous configurations
- **driverinfo.nix** - Hardware driver information and diagnostic tool

### Development Tools
- **tmux-sessionizer.nix** - Tmux session management utility for organizing development environments
- **extract.nix** - Universal archive extraction tool supporting multiple formats

### Utilities
- **launcher.nix** - Application launcher with enhanced features
- **underwatt.nix** - Power management and monitoring utility

## Script Architecture

### Module Structure
Each script is packaged as a Nix derivation with:
- Source code or script content
- Runtime dependencies
- Shell completion if applicable
- Installation path configuration

### Package Pattern
```nix
# Example script packaging
{ pkgs, ... }:

pkgs.writeShellScriptBin "script-name" ''
  #!/usr/bin/env bash
  # Script content here
  dependencies="${pkgs.dependency1}/bin/dep1 ${pkgs.dependency2}/bin/dep2"
  # Script implementation
''
```

## Core Scripts

### rebuild.nix
**Purpose**: Enhanced system rebuilding with automation features

**Features**:
- Automatic username detection and updates
- Hardware configuration synchronization
- Colored output and error handling
- Flake location detection (supports both `$HOME/NixOS` and `/etc/nixos`)
- Safety checks and validation

**Usage**:
```bash
rebuild          # Full system rebuild and switch
rebuild test     # Test configuration without switching
rebuild boot     # Build for next boot only
```

### rollback.nix
**Purpose**: Quick system rollback to previous configurations

**Features**:
- Lists available system generations
- Interactive rollback selection
- Boot configuration updates
- Safe rollback with confirmation

**Usage**:
```bash
rollback         # Interactive rollback menu
rollback n       # Rollback to generation n
```

### tmux-sessionizer.nix
**Purpose**: Organize and manage tmux development sessions

**Features**:
- Create new sessions with predefined layouts
- Switch between existing sessions
- Integration with development workflows
- Session persistence across reboots

**Usage**:
```bash
tmux-sessionizer    # Interactive session menu
tmux-sessionizer project-name  # Create/join project session
```

## Utility Scripts

### extract.nix
**Purpose**: Universal archive extraction tool

**Supported Formats**:
- tar, tar.gz, tar.bz2, tar.xz
- zip, rar, 7z
- gz, bz2, xz
- And many more formats

**Usage**:
```bash
extract archive.tar.gz
extract -d output/ archive.zip
```

### launcher.nix
**Purpose**: Enhanced application launcher

**Features**:
- Application search and launch
- Recent application tracking
- Custom categories and filtering
- Integration with desktop environment

### driverinfo.nix
**Purpose**: Hardware driver information tool

**Features**:
- Display loaded kernel modules
- Show GPU driver information
- List available hardware devices
- Diagnostic output for troubleshooting

### underwatt.nix
**Purpose**: Power management and monitoring

**Features**:
- Battery status and health
- Power consumption monitoring
- Power saving mode toggles
- Thermal information display

## Script Installation

Scripts are installed through the `default.nix` module:

```nix
# Example script installation
environment.systemPackages = with pkgs; [
  (import ./rebuild.nix { inherit pkgs; })
  (import ./tmux-sessionizer.nix { inherit pkgs; })
  # Additional scripts...
];
```

## Adding New Scripts

1. **Create Script File**: Write the script in `.nix` format
2. **Define Dependencies**: List required packages
3. **Add to Module**: Include in `default.nix` for installation
4. **Test Functionality**: Verify script works as expected
5. **Update Documentation**: Add script description and usage

### Script Template
```nix
{ pkgs, ... }:

pkgs.writeShellScriptBin "new-script" ''
  #!/usr/bin/env bash
  set -euo pipefail

  # Dependencies
  DEP1="${pkgs.dependency1}/bin/dep1"

  # Script implementation
  echo "New script functionality"

  # Main logic
  main() {
    # Your code here
  }

  main "$@"
''
```

## Integration Points

### With System Services
- Scripts may interact with system services
- Integration with systemd or other init systems
- Service status monitoring and management

### With Desktop Environment
- Integration with desktop menus
- Application launcher integration
- Desktop notifications

### With Development Workflow
- Tmux session management
- Development environment setup
- Build and deployment automation

## Best Practices

1. **Error Handling**: Include proper error checking and handling
2. **Dependencies**: Clearly declare all required dependencies
3. **Documentation**: Include usage examples and help text
4. **Safety**: Implement safety checks for destructive operations
5. **Testing**: Test scripts in various scenarios

## Usage Examples

### System Management
```bash
# Rebuild with automatic username update
rebuild

# Check system generations
rollback list

# Rollback to previous generation
rollback 2
```

### Development Workflow
```bash
# Create development session
tmux-sessionizer my-project

# Extract downloaded project
extract project.tar.gz

# Check hardware status
driverinfo
```

### Power Management
```bash
# Check battery status
underwatt status

# Enable power saving
underwatt powersave on
```

## Troubleshooting

### Script Not Found
1. Verify script is installed in system packages
2. Check script permissions and executable bit
3. Rebuild system: `sudo nixos-rebuild switch --flake ".#Default"`
4. Check script path in PATH variable

### Permission Issues
1. Check script execution permissions
2. Verify required system permissions
3. Check user/group ownership
4. Test with appropriate user privileges

### Dependency Issues
1. Verify all dependencies are declared
2. Check if required packages are installed
3. Test dependency availability
4. Update dependency versions if needed

## Maintenance

### Regular Updates
- Review and update script dependencies
- Add new features based on user needs
- Fix bugs and improve error handling
- Update documentation for new features

### Performance Monitoring
- Monitor script execution times
- Check resource usage patterns
- Optimize heavy operations
- Implement caching where appropriate

## Security Considerations

- Validate user input and parameters
- Use absolute paths for dependencies
- Implement proper permission checks
- Avoid insecure operations
- Audit script for potential vulnerabilities