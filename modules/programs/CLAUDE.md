# Programs Modules

This directory contains configurations for various applications and programs organized by category. Each subdirectory focuses on a specific type of software.

## Directory Structure

- **browser/** - Web browsers and browser-related tools
- **cli/** - Command-line interface tools and utilities
- **editor/** - Text editors and development environments
- **media/** - Media players, communication, and creative software
- **misc/** - Miscellaneous applications that don't fit other categories
- **terminal/** - Terminal emulators and shell tools

## Module Selection Logic

Program modules are conditionally imported based on variables in `hosts/Default/variables.nix`:

```nix
# Example variable-driven selection
variables = {
  terminal = "kitty";     # Enables modules/programs/terminal/kitty/
  browser = "firefox";    # Enables modules/programs/browser/firefox/
  editor = "nvim";        # Enables modules/programs/editor/nixvim/
  fileManager = "yazi";   # Enables modules/programs/cli/yazi/
}
```

## Module Categories

### Browser Modules
Located in `browser/` - Configurations for web browsers:
- Firefox and derivatives (Floorp, Zen)
- Browser extensions and themes
- Default browser settings
- Privacy and security configurations

### CLI Tools
Located in `cli/` - Command-line utilities:
- File managers (yazi, lf)
- Version control (lazygit, git tools)
- System monitoring and debugging tools
- Development utilities (direnv, tmux)
- Package managers and CLI applications

### Editor Configurations
Located in `editor/` - Development environments:
- NixVim (Neovim with Nix configuration)
- VSCode with extensions and settings
- Helix editor configuration
- Doom Emacs configuration
- NvChad (Neovim configuration framework)

### Media Applications
Located in `media/` - Entertainment and creative tools:
- Discord and communication apps
- Spotify and music players (Spicetify)
- Video players and streaming tools
- OBS Studio for recording
- Creative software

### Terminal Emulators
Located in `terminal/` - Terminal applications:
- Kitty terminal
- Alacritty terminal
- Terminal themes and configurations
- Shell integration

### Miscellaneous Tools
Located in `misc/` - Various applications:
- System utilities
- Productivity tools
- Specialized software
- Tools that don't fit other categories

## Working with Program Modules

### Adding New Programs
1. Create or edit the appropriate category file
2. Use conditional imports based on variables
3. Follow existing module patterns
4. Update `hosts/Default/variables.nix` if adding new variables

### Module Structure Pattern
Each program module should:
- Be conditional on relevant variables
- Include proper package declarations
- Handle configuration files and settings
- Include necessary dependencies

### Variable Integration
Programs typically read from:
- `variables.terminal` - Terminal emulator selection
- `variables.browser` - Browser selection
- `variables.editor` - Editor preference
- `variables.fileManager` - File manager choice
- `variables.shell` - Shell preference (zsh/fish/bash)

## Dependencies

Program modules may depend on:
- Core system functionality
- Desktop environment (for GUI applications)
- Hardware support (for GPU acceleration)
- Theme modules (for visual consistency)
- Other program modules (for integration)

## Common Configuration Patterns

### Conditional Imports
```nix
# Example conditional import
config = lib.mkIf (config.variables.terminal == "kitty") {
  programs.kitty = {
    enable = true;
    # ... configuration
  };
}
```

### Package Management
```nix
# Example package inclusion
home.packages = with pkgs; [
  terminalPackage
  # Additional related packages
];
```

### Configuration Files
```nix
# Example config file management
xdg.configFile."application/config".source = ./config-file;
```

## Testing Changes

After modifying program configurations:
1. Test: `home-manager switch --flake ".#Default"`
2. Or rebuild full system: `sudo nixos-rebuild switch --flake ".#Default"`
3. Restart affected applications for changes to take effect

## Best Practices

1. **Use Variables** - Make configurations customizable through variables
2. **Keep Modules Focused** - Each module should handle one category well
3. **Document Dependencies** - Clearly state what each module depends on
4. **Test Individually** - Ensure modules work independently
5. **Follow Conventions** - Use established patterns for consistency

## Integration Points

### With Desktop Environments
- Desktop-specific settings and integrations
- Window rules and desktop entries
- Theme and appearance coordination

### With Themes
- Color scheme integration
- Icon and cursor themes
- Font configurations

### With Hardware
- GPU acceleration for applications
- Peripheral support
- Performance optimizations