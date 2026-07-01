# Cyberpunk 2077 Modding on NixOS

## Status

Core mods (RED4ext, Redscript, ArchiveXL, TweakXL, Cyber Engine Tweaks) installed and working on the latest Steam build (20383525). CET overlay binds to Ctrl and opens in-game.

## Known NixOS-Specific Issue: protontricks vcrun2022 Failure

**Do not use `protontricks <appid> vcrun2022` on NixOS.** It will fail and leave the prefix in a half-installed state.

### Root Cause

Known NixOS bug ([nixpkgs#479497](https://github.com/NixOS/nixpkgs/issues/479497), [protontricks#461](https://github.com/Matoking/protontricks/issues/461)). nixpkgs packages protontricks with `STEAM_RUNTIME=0` hardcoded, which breaks Wine's 32-bit FreeType lookup. When winetricks invokes `wine regedit.exe` to import the vcrun2022 override `.reg`, regedit crashes with status 1 and winetricks aborts. Result: 32-bit DLLs install (syswow64/), 64-bit DLLs do NOT (still Wine builtin stubs in system32/).

CET and RED4ext are 64-bit native DLLs — without the 64-bit VC++ runtime they crash with "no access to memory" / error 998.

### Fix: Manual DLL Extraction

```bash
mkdir -p /tmp/vcrun2022 && cd /tmp/vcrun2022
nix-shell -p cabextract wget --run "
  wget -q https://aka.ms/vs/17/release/vc_redist.x64.exe -O vc_redist.x64.exe
  cabextract -q vc_redist.x64.exe
  cabextract -q a12
"

PFX32=~/.steam/steam/steamapps/compatdata/1091500/pfx/drive_c/windows/system32
mkdir -p "$PFX32/vcrun2022_builtin_backup"

# Back up Wine builtin stubs (skip symlinks)
for dll in msvcp140.dll vcruntime140.dll vcruntime140_1.dll concrt140.dll \
           msvcp140_1.dll msvcp140_2.dll msvcp140_atomic_wait.dll \
           msvcp140_codecvt_ids.dll vccorlib140.dll; do
  [ -e "$PFX32/$dll" ] && [ ! -L "$PFX32/$dll" ] && mv "$PFX32/$dll" "$PFX32/vcrun2022_builtin_backup/$dll"
done

# Copy VC++ 2022 64-bit DLLs (extracted files have _amd64 suffix)
for f in /tmp/vcrun2022/*_amd64; do
  cp -v "$f" "$PFX32/$(basename "$f" _amd64)"
done
```

Cab `a12` contains all amd64 runtime DLLs. Backups saved to `system32/vcrun2022_builtin_backup/` for revert.

## Setup

### Proton prefix dependencies
- `d3dcompiler_47` — installed via `protontricks 1091500 d3dcompiler_47` (this one DOES work on NixOS)
- `vcrun2022` 64-bit DLLs — manual extraction (see above)
- `version` DLL override — set in `user.reg` as `"version"="native,builtin"` (writing this via `protontricks 1091500 --gui` → winecfg → Libraries works)

### Steam launch option
```
WINEDLLOVERRIDES="winmm,version=n,b" %command%
```
Tells Wine to prefer native `winmm.dll` (RED4ext) and `version.dll` (CET) from the game's `bin/x64/` directory over Wine builtins.

### Core mod files installed in game directory
- `bin/x64/winmm.dll` — RED4ext v1.30.0 proxy loader
- `bin/x64/version.dll` — CET v1.37.1 proxy loader
- `red4ext/RED4ext.dll` — RED4ext main
- `red4ext/plugins/ArchiveXL/ArchiveXL.dll` — ArchiveXL v1.26.8
- `red4ext/plugins/TweakXL/TweakXL.dll` — TweakXL v1.11.3
- `bin/x64/plugins/cyber_engine_tweaks.asi` — CET ASI loader
- `engine/tools/scc.exe`, `r6/config/cybercmd/scc.toml` — Redscript v0.5.31

## Key Paths
- Proton prefix: `~/.steam/steam/steamapps/compatdata/1091500/pfx/`
- Game directory: `~/.steam/steam/steamapps/common/Cyberpunk 2077/`
- Steam manifest: `~/.steam/steam/steamapps/appmanifest_1091500.acf`

## What NOT to do
- Do NOT run `protontricks 1091500 vcrun2022` on NixOS — known broken, will abort mid-install
- Do NOT downgrade the game via Steam betas unless a mod explicitly requires an older patch (current RED4ext v1.30.0 supports latest)
- Do NOT run `nixos-rebuild` from an agent — user handles all rebuilds (codemem #277)
- `cabextract` is not installed by default — use `nix-shell -p cabextract` for ephemeral access