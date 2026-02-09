# Terminal Modules

This directory contains configurations for terminal emulators and terminal-related applications. Terminal selection is controlled by `variables.terminal` in `hosts/Default/variables.nix`.

## Available Terminal Emulators

- **kitty/** - Modern, feature-rich terminal emulator with GPU acceleration
- **alacritty/** - Fast, cross-platform terminal emulator written in Rust
- **ghostty/** - Fast, feature-rich, cross-platform terminal emulator with native UI and GPU acceleration

## Terminal Selection

The terminal emulator is selected based on:
```nix
# In hosts/Default/variables.nix
terminal = "kitty";  # Options: "kitty", "alacritty", "ghostty"
```

## Configuration Features

### Kitty Terminal
- **Performance**: GPU-accelerated rendering
- **Features**: Split panes, tabs, keyboard shortcuts
- **Themes**: Extensive theme support
- **Fonts**: Advanced font configuration
- **Integration**: Shell integration and remote control

### Alacritty Terminal
- **Performance**: Fast and lightweight
- **Cross-Platform**: Consistent across systems
- **Configuration**: YAML-based configuration
- **Rendering**: Software rendering with optional GPU
- **Integration**: Good shell and font support

### Ghostty Terminal
- **Performance**: GPU-accelerated with native platform UI
- **Cross-Platform**: Native on macOS, Linux, Windows
- **Configuration**: INI-based configuration with Home Manager module
- **Rendering**: Hardware-accelerated with GPU optimization
- **Integration**: Full shell integration, systemd support, and modern features
- **Shell Integration**: Automatic for bash, fish, zsh
- **Systemd Support**: Faster startup and additional features on Linux
- **Themes**: Built-in Catppuccin support, custom theme support
- **Editor Integration**: Vim and bat syntax highlighting

## Common Terminal Features

### Shell Integration
- Prompt customization
- Command completion
- History management
- Directory navigation

### Appearance Customization
- Color schemes and themes
- Font configuration and rendering
- Transparency and blur effects
- Window decorations

### Performance Features
- Fast rendering and scrolling
- Efficient memory usage
- Hardware acceleration (where available)
- Optimized for terminal applications

### Advanced Functionality
- Split panes and tabs
- Unicode and emoji support
- Image display (kitty)
- Custom keybindings

## Configuration Patterns

### Conditional Loading
```nix
config = lib.mkIf (config.variables.terminal == "kitty") {
  programs.kitty = {
    enable = true;
    # Configuration here
  };
}
```

### Theme Configuration
```nix
# Example theme setup
themeFile = "theme-name";
settings = {
  foreground = "#ffffff";
  background = "#000000";
  # Additional colors...
};
```

### Font Configuration
```nix
# Example font settings
font = {
  name = "JetBrains Mono";
  size = 12;
};
```

## Integration Points

### With Shell Configuration
- Terminal-specific shell initialization
- Integration with zsh/bash/fish
- Custom aliases and functions
- Environment variable setup

### With Desktop Environment
- Desktop entries and menu integration
- Keybinding integration
- Theme consistency
- Window management

### With Applications
- Default terminal for other applications
- Terminal emulator for development tools
- Integration with file managers
- Terminal-based application support

## Advanced Configuration

### Performance Tuning
- GPU acceleration settings
- Memory optimization
- Render backend selection
- Buffer size optimization

### Accessibility Features
- Font scaling and sizing
- High contrast themes
- Screen reader compatibility
- Keyboard navigation

### Security Features
- Secure terminal handling
- Copy/paste security
- Input validation
- Process isolation

## Dependencies

Terminal emulators depend on:
- System fonts and fontconfig
- Shell configuration (zsh/bash/fish)
- Theme modules for visual consistency
- Desktop environment for proper integration
- GPU drivers for hardware acceleration

## Choosing a Terminal

### Kitty
**Best for**: Users who want advanced features and GPU acceleration
**Pros**: Fast, feature-rich, good rendering, split panes
**Cons**: Heavier resource usage, complex configuration

### Alacritty Terminal
**Best for**: Users who want a fast, simple terminal
**Pros**: Lightweight, fast startup, simple configuration
**Cons**: Fewer built-in features, limited customization

### Ghostty Terminal
**Best for**: Users who want a modern, fast terminal with native UI and excellent GPU acceleration
**Pros**: Fast startup, modern UI, systemd integration, cross-platform, good shell integration, Vim/bat support
**Cons**: Newer project, smaller community than kitty/alacritty

## Terminal-Specific Configuration

### Kitty Features
- Tab management (`ctrl+shift+t`)
- Split panes (`ctrl+shift+enter`)
- Remote control capabilities
- Image display in terminal
- Advanced font rendering

### Alacritty Features
- Minimal resource usage
- Fast startup time
- Simple YAML configuration
- Good cross-platform consistency
- Stable performance

### Ghostty Features
- Fast startup and rendering
- Native platform UI (macOS, Linux, Windows)
- Hardware-accelerated GPU rendering
- Systemd integration for better performance
- Full shell integration (bash, fish, zsh)
- Built-in Catppuccin themes
- Custom theme support
- Vim and bat syntax highlighting
- Modern keybinding system
- Configurable scrollback and history

## Customization Examples

### Color Schemes
```nix
# Custom color scheme
colors = {
  primary = {
    foreground = "#ffffff";
    background = "#1e1e1e";
  };
  normal = {
    black = "#000000";
    red = "#ff5555";
    # Additional colors...
  };
};
```

### Keybindings
```nix
# Custom keybindings
keybindings = {
  "ctrl+shift+c" = "copy_to_clipboard";
  "ctrl+shift+v" = "paste_from_clipboard";
  "ctrl+shift+t" = "new_tab";
};
```

## Testing Changes

After modifying terminal configurations:
1. Restart the terminal emulator completely
2. Test color schemes and themes
3. Verify font rendering
4. Test keybindings and features
5. Check integration with shell

## Adding New Terminal Emulators

1. Create new directory for terminal
2. Add package configuration
3. Implement theme support
4. Add integration points
5. Update variables and imports
6. Test thoroughly

## Troubleshooting

### Performance Issues
- Disable GPU acceleration if causing problems
- Reduce font complexity
- Check system resources
- Update graphics drivers

### Font Problems
- Verify font installation
- Check fontconfig configuration
- Test different font families
- Adjust font rendering settings

### Theme Issues
- Verify theme file format
- Check color syntax
- Test with simple themes first
- Restart terminal completely

### Integration Problems
- Check desktop integration
- Verify shell configuration
- Test with different applications
- Check environment variables

## Best Practices

1. **Performance First** - Optimize for speed and responsiveness
2. **Consistent Theming** - Match system theme colors
3. **Accessible Design** - Ensure readability and usability
4. **Minimal Configuration** - Keep settings focused and necessary
5. **Regular Testing** - Verify functionality after changes