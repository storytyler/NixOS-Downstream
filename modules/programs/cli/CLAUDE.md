# CLI Tools Modules

This directory contains configurations for command-line interface tools and utilities. These tools enhance productivity and provide powerful system management capabilities.

## Categories of CLI Tools

### File Management
- **yazi/** - Modern terminal file manager with image preview
- **lf/** - Lightweight file manager with vim-like keybindings
- File operations and navigation tools

### Version Control
- **git/** - Git configuration and related tools
- **lazygit/** - Terminal UI for Git operations
- Git utilities and aliases

### Development Tools
- **direnv/** - Environment variable management per directory
- **tmux/** - Terminal multiplexer
- Development shells and environments

### System Utilities
- System monitoring and debugging tools
- Network diagnostic utilities
- Process management tools
- System information display

### Productivity Tools
- Task management
- Note-taking applications
- Calendar and scheduling
- Text processing utilities

## Configuration Pattern

Each CLI tool module typically includes:
- Package installation
- Configuration file management
- Shell aliases and functions
- Integration with other tools
- Theme and appearance settings

## Variable Integration

CLI tools may be controlled by variables from `hosts/Default/variables.nix`:
```nix
# Example variable usage
variables = {
  fileManager = "yazi";     # Enables yazi file manager
  shell = "zsh";            # Configures shell-related tools
  editor = "nvim";          # Sets default editor for CLI tools
}
```

## Module Structure

### File Managers
- Package configuration
- Keybinding customization
- Preview and display settings
- Integration with file associations

### Development Tools
- Environment setup
- Aliases and shortcuts
- Integration with editors
- Custom functions and scripts

### System Tools
- Monitoring configuration
- Diagnostic settings
- Output formatting
- Logging preferences

## Common Features

### Shell Integration
- Bash/Zsh/Fish compatibility
- Completion scripts
- Custom aliases
- Environment variables

### Theme Support
- Color scheme consistency
- Icon support where applicable
- Font configuration
- Visual customization

### Performance Optimization
- Efficient configurations
- Minimal resource usage
- Fast startup times
- Caching settings

## Configuration Examples

### Package Installation
```nix
home.packages = with pkgs; [
  toolName
  relatedTool1
  relatedTool2
];
```

### Configuration Files
```nix
xdg.configFile."tool/config" = {
  source = ./config-file;
  # Optional: executable = true;
};
```

### Shell Integration
```nix
programs.bash.shellAliases = {
  tool = "tool --custom-flags";
};
```

## Dependencies

CLI tools may depend on:
- Shell configuration (zsh/bash/fish)
- Terminal emulator settings
- System permissions and access
- Network configuration for remote tools

## Integration Points

### With Editors
- Default editor integration
- File opening from file managers
- Development environment setup

### With Desktop Environment
- Terminal launcher integration
- Desktop entries for GUI CLI tools
- Theme consistency

### With System
- Path configuration
- Permission setup
- Service integration

## Adding New CLI Tools

1. Create configuration file for the tool
2. Add package dependencies
3. Configure integration points
4. Add variable controls if needed
5. Update documentation
6. Test functionality

## Best Practices

1. **Modular Configuration** - Keep tools independent
2. **Consistent Integration** - Follow existing patterns
3. **Performance First** - Optimize for speed and efficiency
4. **User Customization** - Allow easy personalization
5. **Documentation** - Include usage examples

## Testing Changes

After modifying CLI configurations:
1. Start a new shell session
2. Test individual tool functionality
3. Verify integrations work
4. Check shell aliases and functions

## Troubleshooting

### Tools Not Found
- Verify package installation
- Check PATH configuration
- Restart shell session

### Configuration Not Applied
- Verify config file locations
- Check file permissions
- Restart affected tool

### Integration Issues
- Check dependency chain
- Verify variable settings
- Test related components