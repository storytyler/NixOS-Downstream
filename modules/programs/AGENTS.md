# Program Configuration Modules

Applications organized by category with variable-driven selection. ~40 modules across 6 categories.

## STRUCTURE
```
modules/programs/
├── browser/     # firefox, floorp, zen, chromium, browseros
├── cli/         # yazi, lf, lazygit, tmux, btop, cava, direnv, fastfetch, voicemode, spec-kit
├── editor/      # vscode, helix
├── media/       # discord, spicetify, youtube-music, obs-studio, mpv, thunderbird
├── misc/        # tlp, lact, thunar, cpufreq (cpufreq unused by any host)
└── terminal/    # kitty, alacritty, ghostty
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Add browser | `browser/{name}/` | All Firefox derivatives share: default.nix + settings.nix + bookmarks.nix + search.nix + policies.nix |
| Add editor | `editor/{name}/` | VSCode (extensions, Vim keybinds, Catppuccin), Helix |
| Add CLI tool | `cli/{name}/` | File managers, git tools, monitoring |
| Add terminal | `terminal/{name}/` | Kitty (Catppuccin), Alacritty, Ghostty (custom Catppuccin) |
| Configure program | Use `home-manager.sharedModules` | Dominant pattern for program configs |

## CONVENTIONS
- **Program modules use `home-manager.sharedModules`** to inject configs into all HM users
- Conditional imports via `variables.{terminal,browser,editor,tuiFileManager,shell}`
- Browser config pattern: Betterfox hardening via `inputs.betterfox` for all Firefox derivatives
- Config files via `xdg.configFile."app/config".source = ./config-file`
- Always-loaded CLI tools: tmux, direnv, lazygit, cava, btop (not variable-selected)

## ANTI-PATTERNS
- DON'T install all programs - use variable-driven selection
- DON'T mix categories - keep browser/editor/terminal separate
- DON'T create program modules without `home-manager.sharedModules` pattern
