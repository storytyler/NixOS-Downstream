# Editor Modules

This directory contains configurations for text editors and development environments. Editor selection is controlled by `variables.editor` in `hosts/Default/variables.nix`.

## Available Editors

- **nixvim/** - Neovim configured entirely with Nix (modular, reproducible)
- **vscode/** - Visual Studio Code with extensions and settings
- **helix/** - Helix editor with Kakoune-like keybindings
- **doom-emacs/** - Emacs with Doom Emacs framework
- **nvchad4nix/** - Neovim with NvChad configuration

## Editor Selection

The editor is selected based on:
```nix
# In hosts/Default/variables.nix
editor = "nvim";  # Options: "nvim", "vscode", "helix", "emacs", "nvchad"
```

## Configuration Philosophy

Each editor module provides:
- Complete, working configuration
- Language-specific support
- Theme and appearance customization
- Plugin/extension management
- Integration with system tools

## Editor-Specific Features

### NixVim
- **Modular Configuration**: Each feature in separate modules
- **Language Support**: LSP, formatting, linting per language
- **Themes**: Multiple color schemes available
- **Keybindings**: Customizable keymaps and which-key
- **Plugins**: Comprehensive plugin ecosystem

### VSCode
- **Extensions**: Marketplace extensions via Nix
- **Settings**: Complete settings.json configuration
- **Keybindings**: Custom keybinding configurations
- **Themes**: Color and icon themes
- **Integration**: Git, Docker, development tools

### Helix
- **Built-in Features**: LSP, tree-sitter, file picker
- **Configuration**: TOML-based configuration files
- **Themes**: Custom color schemes
- **Keybindings**: Modal editing with multiple selections
- **Performance**: Fast startup and response

### Doom Emacs
- **Framework**: Doom Emacs modules and configuration
- **Modules**: Language-specific modules enabled/disabled
- **Performance**: Optimized startup times
- **Themes**: Doom and custom themes
- **Packages**: Package management through use-package

### NvChad
- **Framework**: NvChad base configuration
- **UI/UX**: Modern interface with telescope, which-key
- **Customization**: Easy personalization
- **Plugins**: Curated plugin selection
- **Performance**: Optimized Neovim experience

## Common Features Across Editors

### Language Support
- Syntax highlighting
- Code completion (LSP)
- Error checking and linting
- Code formatting
- Debugging integration

### Integration
- Git integration
- File manager integration
- Terminal integration
- System clipboard
- File associations

### Customization
- Theme and colors
- Font configuration
- Keybinding customization
- Plugin/extension management
- UI layout options

## Configuration Patterns

### Conditional Loading
```nix
config = lib.mkIf (config.variables.editor == "nvim") {
  programs.nixvim = {
    enable = true;
    # Configuration here
  };
}
```

### Language Configuration
```nix
# Example language server setup
lsp = {
  enable = true;
  servers = {
    rust-analyzer.enable = true;
    tsserver.enable = true;
  };
};
```

## Dependencies

Editor modules may depend on:
- Language servers and compilers
- Development tools and formatters
- Theme modules for visual consistency
- Terminal configurations
- System fonts

## Integration Points

### With Development Tools
- LSP servers
- Debuggers
- Build tools
- Testing frameworks

### With System
- File associations
- Default editor settings
- Theme integration
- Font configuration

### With CLI Tools
- Git integration
- Terminal usage
- File management
- System utilities

## Choosing an Editor

### NixVim
**Best for**: Users who want reproducible, modular Neovim configuration with Nix
**Pros**: Declarative, version-controlled, highly customizable
**Cons**: Nix learning curve

### VSCode
**Best for**: Users who want full-featured IDE with GUI
**Pros**: Large extension ecosystem, good debugging, intuitive UI
**Cons**: Heavier resource usage, Microsoft product

### Helix
**Best for**: Users who want modern, fast modal editing out of the box
**Pros**: Built-in LSP, fast, simple configuration
**Cons**: Smaller plugin ecosystem

### Doom Emacs
**Best for**: Users who want Emacs with modern configuration
**Pros**: Extremely powerful, unmatched customization
**Cons**: Steep learning curve, different paradigm

### NvChad
**Best for**: Users who want polished Neovim with minimal setup
**Pros**: Beautiful UI, good defaults, easy customization
**Cons**: Less control than pure NixVim

## Testing Changes

After modifying editor configurations:
1. Restart the editor for changes to take effect
2. Test language-specific functionality
3. Verify theme and appearance
4. Check plugin/extension functionality

## Adding New Editors

1. Create new directory for editor
2. Add base package configuration
3. Implement language support
4. Add theme integration
5. Update variables and imports
6. Test thoroughly

## Common Troubleshooting

### Language Support Not Working
- Check language server installation
- Verify LSP configuration
- Restart editor after changes

### Performance Issues
- Disable heavy plugins/extensions
- Check for conflicting configurations
- Verify system resources

### Theme Issues
- Verify theme installation
- Check syntax highlighting
- Restart editor completely