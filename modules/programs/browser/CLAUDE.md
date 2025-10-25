# Browser Modules

This directory contains configurations for web browsers and browser-related tools. The browser selection is controlled by `variables.browser` in `hosts/Default/variables.nix`.

## Supported Browsers

- **firefox/** - Mozilla Firefox with custom configurations
- **floorp/** - Floorp browser (Firefox-based with additional features)
- **zen/** - Zen browser (privacy-focused Firefox derivative)

## Configuration Structure

Each browser module includes:
- Package installation and configuration
- Profile settings and preferences
- Extension management
- Theme and appearance customization
- Privacy and security settings
- Integration with system themes

## Variable Selection

The browser is selected based on:
```nix
# In hosts/Default/variables.nix
browser = "firefox";  # Options: "firefox", "floorp", "zen"
```

## Common Features

### Privacy Configuration
- Enhanced tracking protection
- Cookie and history management
- Fingerprinting protection
- Private browsing settings

### Performance Optimization
- Hardware acceleration
- Memory management
- Startup optimization
- Tab management settings

### Theme Integration
- System theme following
- Custom CSS and theming
- Icon and cursor integration
- Font configuration

### Extension Management
- Essential extensions configuration
- Privacy-enhancing extensions
- Development tools
- Productivity extensions

## Browser-Specific Notes

### Firefox
- Most mature configuration
- Extensive customization options
- Large extension ecosystem
- Good privacy controls

### Floorp
- Enhanced user interface
- Additional privacy features
- Built-in customization tools
- Firefox-based compatibility

### Zen
- Privacy-focused design
- Minimalist approach
- Built-in ad blocking
- Simplified interface

## Configuration Patterns

### Conditional Imports
```nix
config = lib.mkIf (config.variables.browser == "firefox") {
  programs.firefox = {
    enable = true;
    # Configuration here
  };
}
```

### Settings Management
```nix
# Example settings
settings = {
  "browser.startup.homepage" = "https://example.com";
  "privacy.trackingprotection.enabled" = true;
};
```

## Dependencies

Browser modules depend on:
- Core system functionality
- Desktop environment (for proper integration)
- Theme modules (for consistent appearance)
- Network settings from core modules

## Integration Points

### With Desktop Environment
- Default browser assignment
- MIME type associations
- Protocol handlers
- Desktop entry creation

### With Themes
- GTK theme integration
- Icon theme support
- Font configuration
- Color scheme following

## Testing Changes

After modifying browser configurations:
1. Restart the browser for changes to take effect
2. Check settings in about:config (Firefox-based)
3. Verify extension functionality
4. Test theme integration

## Adding New Browsers

1. Create a new directory for the browser
2. Add package configuration
3. Implement settings and preferences
4. Update variables to include new option
5. Add conditional imports in parent module
6. Test functionality and integration

## Common Troubleshooting

### Browser Not Starting
- Check if package is properly installed
- Verify GPU drivers for hardware acceleration
- Check system logs for errors

### Settings Not Applying
- Verify configuration syntax
- Check for conflicting settings
- Restart browser completely
- Clear browser cache if needed

### Theme Issues
- Verify theme module is working
- Check GTK/Qt theme configuration
- Restart display manager if needed