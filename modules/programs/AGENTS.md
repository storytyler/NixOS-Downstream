# Program Configuration Modules

Applications organized by category with variable-driven selection.

## STRUCTURE
```
modules/programs/
├── browser/     # Web browsers (firefox, floorp, zen)
├── cli/          # Command-line tools (yazi, lazygit, tmux)
├── editor/       # Development environments (nixvim, vscode, helix, doom-emacs, nvchad)
├── media/        # Media and communication apps (discord, spotify, obs)
├── misc/         # Miscellaneous applications
└── terminal/     # Terminal emulators (kitty, alacritty)
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Add browser | `modules/programs/browser/{name}/` | Firefox derivatives, extensions, privacy settings |
| Add editor | `modules/programs/editor/{name}/` | NixVim, VSCode, Helix, Doom Emacs, NvChad |
| Add CLI tool | `modules/programs/cli/{name}/` | File managers, git tools, monitoring |
| Configure program | Use conditional import pattern | `lib.mkIf (config.variables.X == "Y")` |

## CONVENTIONS
- Conditional imports: `config = lib.mkIf (config.variables.category == "option")`
- Variables: `variables.terminal`, `variables.browser`, `variables.editor`, `variables.fileManager`, `variables.shell`
- Config files via `xdg.configFile."app/config".source = ./config-file`

## ANTI-PATTERNS
- DON'T install all programs - use variable-driven selection
- DON'T mix categories - keep browser/editor/terminal separate
