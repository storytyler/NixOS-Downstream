# AGENTS.md

## Build/Lint/Test Commands
- `nix fmt` - Format all Nix files using nixfmt-tree
- `nix flake check` - Validate flake configuration and check for issues
- `nix flake update` - Update all flake inputs
- `nix develop -t template-name` - Enter development shell for specific language
- `rebuild` - Custom rebuild script with auto-username sync and hardware detection

## Code Style Guidelines
- **Imports**: Group standard library, nixpkgs, and custom imports; use `lib` prefix for nixpkgs imports
- **Formatting**: Use nixfmt-tree for consistent formatting; 2-space indentation
- **Naming**: Use kebab-case for filenames, snake_case for variables, PascalCase for attributes
- **Error Handling**: Prefer `lib.assertions` and `lib.warn` for validation; provide descriptive error messages
- **Structure**: Follow Nix conventions with `rec` for recursive attributes, `mkDerivation` for packages
- **Documentation**: Include meta attributes with description, homepage, license, maintainers
- **Testing**: Add packages to pkgs/ directory with proper fetcher expressions and hash verification