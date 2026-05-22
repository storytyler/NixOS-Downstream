# skwd-wall config.json — Field Reference

Generated from: github.com/liixini/skwd-wall reference doc
Module: `programs/skwd-wall/default.nix`
Config path: `~/.config/skwd-wall/config.json` (managed declaratively via Nix)

---

## 1. Compositor & System

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `compositor` | string | `"niri"` | `"hyprland"` | Compositor type. Controls wallpaper backend behavior. |
| `monitor` | string | `""` | `""` | Default monitor for wallpaper. Empty = all monitors. |

---

## 2. General Behavior

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `locale` | string | `""` | `""` | UI language override. Empty = auto-detect. |
| `closeOnSelection` | bool | `false` | `false` | Auto-close picker after selecting a wallpaper. |
| `reopenAtLastSelection` | bool | `false` | `false` | Scroll to last-selected wallpaper on reopen. |
| `wallpaperMute` | bool | `true` | `true` | Mute video wallpapers by default. |
| `pickOnlyMode` | bool | `false` | `false` | Only return path without applying. Useful for scripting. |
| `externalWallpaperCommand` | string | `""` | `""` | Custom shell command to apply wallpapers. |

---

## 3. Paths

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `wallpaper` | string | `"~/Pictures/Wallpapers"` | nix store `${../../../../themes/wallpapers}` | Base directory for image wallpapers. |
| `videoWallpaper` | string | `"~/videowalls"` | nix store (same as wallpaper) | Base directory for video wallpapers. |
| `cache` | string | `""` | `""` | Cache dir for thumbnails, color data, metadata. Empty = `~/.cache/skwd-wall/`. |
| `templates` | string | `""` | `""` | Custom matugen template directory. Empty = built-in. |
| `scripts` | string | `""` | `""` | Custom reload scripts directory. Empty = built-in. |
| `steam` | string | `""` | `""` | Steam install path. Auto-detected if empty. |
| `steamWorkshop` | string | `""` | `""` | Steam Workshop content path. Auto-detected if empty. |
| `steamWeAssets` | string | `""` | `""` | Wallpaper Engine assets path. Auto-detected if empty. |

---

## 4. Features (Toggles)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `matugen` | bool | `true` | `true` | Enable automatic color palette extraction from wallpapers. **Requires matugen binary on PATH.** |
| `ollama` | bool | `false` | `false` | Enable AI auto-tagging via Ollama vision models. |
| `steam` | bool | `false` | `false` | Enable Steam Workshop Wallpaper Engine browser. |
| `wallhaven` | bool | `true` | `true` | Enable Wallhaven.cc wallpaper browsing. |

---

## 5. Color Extraction

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `colorSource` | string | `"magick"` | `"magick"` | Color extraction method. `"magick"` = ImageMagick. |

---

## 6. Matugen (Theme Generation)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `schemeType` | string | `"scheme-fidelity"` | `"scheme-fidelity"` | Material You color scheme type. |
| `mode` | string | `"dark"` | `"dark"` | Color mode: `"dark"` or `"light"`. |

**Available scheme types:** `scheme-content`, `scheme-expressive`, `scheme-fidelity`, `scheme-fruit-salad`, `scheme-monochrome`, `scheme-neutral`, `scheme-rainbow`, `scheme-tonal-spot`, `scheme-vibrant`

---

## 7. Integrations (Matugen Templates)

Array of objects. Each entry: matugen template → output file → optional reload command.

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Integration identifier. |
| `template` | string | Matugen template filename from `data/matugen/templates/`. |
| `output` | string | Output file path. Supports `~` expansion. |
| `reload` | string | *(optional)* Shell command after writing (e.g. `pkill -USR1 kitty`). |

### Our Current Integrations

| Name | Template | Output |
|------|----------|--------|
| `skwd-wall` | `quickshell-colors.json` | `colors.json` |
| `skwd` | `quickshell-colors.json` | `~/.cache/skwd/colors.json` |

### All 15 Built-in Templates

| Name | Template | Default Output | Reload Command |
|------|----------|---------------|----------------|
| `skwd-wall` | `quickshell-colors.json` | `colors.json` | — |
| `skwd` | `quickshell-colors.json` | `~/.cache/skwd/colors.json` | — |
| `kitty` | `kitty.conf` | `~/.config/kitty/skwd-theme.conf` | `pkill -USR1 kitty` |
| `ghostty` | `ghostty.conf` | `~/.config/ghostty/skwd-theme` | `pkill -USR2 ghostty` |
| `niri` | `niri-colors.kdl` | `niri-primary-color` | script |
| `kde` | `kde-colors.colors` | `~/.local/share/color-schemes/SkwdMatugen.colors` | script |
| `vscode` | `vscode-theme.json` | `~/.vscode/extensions/.../matugen-color-theme.json` | — |
| `vesktop` | `vesktop.css` | `~/.config/vesktop/themes/kitty-match.css` | — |
| `spicetify` | `spicetify.ini` | `~/.config/spicetify/Themes/Matugen/color.ini` | script |
| `spicetify-css` | `spicetify.css` | `~/.config/spicetify/Themes/Matugen/user.css` | — |
| `yazi` | `yazi-theme.toml` | `~/.config/yazi/theme.toml` | — |
| `qt6ct` | `qt6ct-colors.conf` | `~/.config/qt6ct/colors/matugen.conf` | — |
| `zen` | `zen.css` | `~/.config/zen/PROFILE/chrome/userChrome.css` | — |

Additional templates (not wired by default): `omp.json` (Oh My Posh), `omp-env.sh`, `zen-content.css`.

---

## 8. Visual Display (Wallpaper Selector)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `displayMode` | string | `"slices"` | `"slices"` | `"slices"` (parallelogram carousel), `"grid"`, or `"hex"`. |
| `sliceSpacing` | int | `-30` | `-30` | Spacing between slices. Negative = overlap. |
| `hexScrollStep` | int | `1` | `1` | Hexagons scrolled per step in hex mode. |
| `customPresets` | object | `{}` | `{}` | User-defined display presets. |

---

## 9. Post-Processing (Hooks)

Array of shell commands executed after wallpaper selection.

| Placeholder | Expands To |
|-------------|-----------|
| `%path%` | Full file path of selected wallpaper |
| `%type%` | Media type: `image`, `video`, or `we` |
| `%name%` | Filename without extension |

Our value: `[]` (none configured)

Example:
```json
"postProcessing": [
    "hyprctl hyprsunset identity",
    "notify-send 'Wallpaper set' '%name%'"
]
```

---

## 10. Performance & Optimization

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `imageOptimizePreset` | string | `"balanced"` | `"balanced"` | `"fast"`, `"balanced"`, `"quality"`. |
| `imageOptimizeResolution` | string | `"2k"` | `"2k"` | `"1080p"`, `"2k"`, `"4k"`, `"original"`. |
| `videoConvertPreset` | string | `"balanced"` | `"balanced"` | Video conversion quality (WIP). Same options. |
| `videoConvertResolution` | string | `"2k"` | `"2k"` | Video target resolution. Same options. |
| `autoOptimizeImages` | bool | `false` | `false` | Auto-optimize new images on add. |
| `autoConvertVideos` | bool | `false` | `false` | Auto-convert new videos on add. |
| `imageTrashDays` | int | `7` | `7` | Days before trashed originals eligible for deletion. |
| `videoTrashDays` | int | `7` | `7` | Same for video. |
| `autoDeleteImageTrash` | bool | `false` | `false` | Auto-purge trashed images after retention. |
| `autoDeleteVideoTrash` | bool | `false` | `false` | Auto-purge trashed videos after retention. |

---

## 11. Ollama (AI Tagging)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `url` | string | `"http://localhost:11434"` | `"http://localhost:11434"` | Ollama API endpoint. |
| `model` | string | `"gemma3:4b"` | `"gemma3:4b"` | Vision model for auto-tagging. |
| `consolidateEnabled` | bool | `true` | `true` | Merge similar tags (experimental). |

---

## 12. Steam (Workshop Browser)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `apiKey` | string | `""` | `""` | Steam Web API key for Workshop browsing. |
| `username` | string | `""` | `""` | Steam username for Steamcmd login. |

---

## 13. Wallhaven (Online Browser)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `apiKey` | string | `""` | `""` | Wallhaven API key for enhanced search/rate limits. |

---

## 14. Wallpaper Engine (Backend)

| Field | Type | Default | Our Value | Description |
|-------|------|---------|-----------|-------------|
| `paper.engine` | string | `"skwd-paper"` | `"skwd-paper"` | `"skwd-paper"` (native video) or `"awwww"`. |

---

## Runtime Dependencies (must be on PATH)

| Package | Purpose | Installed? |
|---------|---------|------------|
| `skwd-daemon` | Background service | Yes (flake) |
| `skwd-paper` | Wallpaper backend | Yes (flake) |
| `matugen` | Color extraction + theming | **No — needs adding** |
| `ffmpeg` | Video thumbnails, transcoding | Check |
| `imagemagick` | Color/saturation extraction | Check |
| `inotify-tools` | Directory change detection | Check |
| `curl` | HTTP requests | Check |
