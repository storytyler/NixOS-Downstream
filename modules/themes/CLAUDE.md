# Theme Modules

This directory contains visual theme configurations for the entire system. Themes provide consistent appearance across desktop environments, applications, and tools.

## Available Themes

- **Catppuccin/** - Catppuccin color palette (mocha, latte, frappe, macchiato variants)
- **Dracula/** - Dracula theme configuration
- **rose-pine/** - Rose Pine theme variants (main, moon, dawn)
- **wallpapers/** - Wallpaper collection and management

## Theme Selection

Themes are typically selected based on variables in `hosts/Default/variables.nix`:

```nix
# Example theme variables
variables = {
  theme = "Catppuccin";      # Main theme selection
  themeVariant = "mocha";    # Theme variant/flavor
  # Additional appearance settings
}
```

## Theme Components

Each theme module typically includes:

### Color Schemes
- GTK theme configuration
- Qt/KDE theme settings
- Terminal color schemes
- Editor themes
- Browser themes

### Visual Elements
- Icon themes
- Cursor themes
- Font configurations
- Wallpaper settings
- Window decorations

### Application Integration
- Browser theming
- Terminal color schemes
- Editor syntax highlighting
- Desktop environment theming
- Application-specific themes

## Theme Structure

### Catppuccin Theme
- **Color Palette**: Soft, pleasant colors with multiple variants
- **Variants**:
  - `mocha` - Dark, warm palette
  - `latte` - Light palette
  - `frappe` - Dark, cool palette
  - `macchiato` - Dark with accent colors
- **Applications**: Comprehensive support for many applications

### Dracula Theme
- **Color Palette**: Dark purple/green theme
- **Applications**: Broad application support
- **Variants**: Standard dark theme

### Rose Pine Theme
- **Color Palette**: Soft, muted colors
- **Variants**:
  - `main` - Dark theme
  - `moon` - Dark with different balance
  - `dawn` - Light theme
- **Applications**: Growing ecosystem support

## Configuration Patterns

### Conditional Theme Loading
```nix
# Example theme selection
config = lib.mkIf (config.variables.theme == "Catppuccin") {
  # Catppuccin configuration here
  gtk.theme = {
    name = "Catppuccin-Mocha-Standard-Blue-Dark";
    package = pkgs.catppuccin-gtk;
  };
};
```

### Color Scheme Application
```nix
# Example color configuration
colors = {
  primary = "#${theme.primary}";
  secondary = "#${theme.secondary}";
  background = "#${theme.background}";
  foreground = "#${theme.foreground}";
};
```

### Wallpaper Configuration
```nfx
# Example wallpaper setup
home.file.".config/background" = {
  source = ./wallpapers/current-wallpaper.jpg;
};
```

## Integration Points

### With Desktop Environment
- GTK and Qt theme application
- Window manager theming
- Icon and cursor themes
- Desktop background configuration

### With Applications
- Terminal color schemes
- Editor syntax highlighting
- Browser themes and extensions
- Application-specific theming

### With System
- Font configuration
- Display settings
- Color management
- Accessibility settings

## Theme Customization

### Color Variants
- Light/dark mode switching
- Accent color customization
- Contrast adjustments
- Personal color modifications

### Visual Elements
- Custom icon themes
- Cursor themes and sizes
- Font selection and sizing
- Wallpaper management

### Application-Specific
- Custom application themes
- Override system theme for specific apps
- Enhanced theming for certain applications

## Adding New Themes

1. Create new directory for theme
2. Define color palette and variants
3. Create application-specific configurations
4. Add wallpaper collection if applicable
5. Update variables to include new theme option
6. Test across applications and desktops

## Theme Management

### Switching Themes
1. Update `variables.theme` in `hosts/Default/variables.nix`
2. Rebuild: `sudo nixos-rebuild switch --flake ".#Default"`
3. Restart applications for full theme application
4. Optionally restart desktop environment

### Customization
- Modify theme files directly for personal preferences
- Create custom variants of existing themes
- Mix and match components from different themes
- Add personal wallpapers and assets

## Performance Considerations

### Resource Usage
- Optimize image sizes for wallpapers
- Use efficient icon themes
- Minimize theme file sizes
- Consider GPU acceleration for themes

### Startup Time
- Pre-cache theme resources
- Optimize theme loading order
- Minimize theme processing during startup

## Troubleshooting

### Theme Not Applying
1. Verify theme selection in variables
2. Check theme package installation
3. Restart affected applications
4. Verify desktop environment integration

### Color Inconsistencies
1. Check application-specific theme support
2. Verify theme variants and colors
3. Test with different applications
4. Consider manual color overrides

### Performance Issues
1. Monitor resource usage
2. Optimize theme assets
3. Consider lighter theme variants
4. Check hardware acceleration

### Wallpaper Problems
1. Verify wallpaper file permissions
2. Check image format compatibility
3. Test different wallpaper files
4. Verify desktop environment support

## Best Practices

1. **Consistency First** - Ensure theme applies consistently across system
2. **Performance Aware** - Optimize themes for system performance
3. **User Choice** - Make theme switching easy and reliable
4. **Documentation** - Include customization instructions
5. **Testing** - Test themes across different environments

## Dependencies

Theme modules depend on:
- Desktop environment configuration
- Application theme support
- Font configuration
- Icon and cursor theme packages
- Wallpaper management tools

## Testing Changes

After modifying theme configurations:
1. Rebuild system: `sudo nixos-rebuild switch --flake ".#Default"`
2. Test theme application across desktop
3. Verify application-specific themes
4. Check performance impact
5. Get user feedback on appearance

## Wallpaper Management

The wallpapers directory contains:
- High-resolution wallpaper images
- Themed wallpaper collections
- Dynamic wallpaper support
- Wallpaper switching utilities

### Wallpaper Selection
- Manual wallpaper selection
- Automatic wallpaper rotation
- Theme-specific wallpaper collections
- Seasonal or time-based wallpapers