# Hardware Configuration Modules

GPU drivers and storage configuration.

## STRUCTURE
```
modules/hardware/
├── drives/       # Drive configurations
│   ├── work.nix
│   └── games.nix
└── video/        # GPU drivers
    ├── nvk.nix
    ├── intel.nix
    ├── amdgpu.nix
    └── nvidia.nix
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| GPU driver | `modules/hardware/video/${vars.videoDriver}.nix` | Options: nvk, intel, amdgpu, nvidia |
| Work drive | `modules/hardware/drives/work.nix` | Work-related storage mount/config |
| Games drive | `modules/hardware/drives/games.nix` | Games storage mount/config |

## CONVENTIONS
- Video driver selected via `variables.videoDriver` - CRITICAL for boot
- Conditional import: `./hardware/video/${vars.videoDriver}.nix` in `modules/default.nix`

## ANTI-PATTERNS
- NEVER change `videoDriver` without matching actual hardware - wrong value causes boot failure
- DON'T modify hardware-configuration.nix manually - it's auto-generated
