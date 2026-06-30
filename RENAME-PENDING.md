# RENAME PENDING — Host Bootstrap Required

The host naming convention was renamed in source on **2026-06-30**, but the
running systems have not yet been rebuilt to pick up the new names. Each
host needs a one-time manual rebuild to regenerate its `rebuild` binary
(which has the hostname baked in at build time via `pkgs.writeShellScriptBin`).

## Convention

| Old name | New name | Role |
|---|---|---|
| `Station-Alpha` | `Hekate` | Primary workstation — crossroads of the homelab |
| `Station-00` (dir `Default`) | `Janus` | AIO touchscreen — gate/threshold |
| `Subrelay-01` | `Medea` | Failover laptop — secondary sorceress |
| `Scout-02` | `Somnus` | Low-power laptop — standby dreamer |

Naming convention: Roman/esoteric, chthonic-nocturnal register. Extensible
to other figures from the same pantheon (Proserpina, Circe, Luna, Portunus,
Terminus, etc.) for future hosts.

## What changed in source

- 4 directories under `hosts/` renamed (`git mv` preserved history)
- `flake.nix` — 4 `nixosConfigurations` keys updated
- 4 `hosts/*/variables.nix` — `hostname` field updated
- Timezone bug fixed in 3 hosts: `"Chicago/US"` → `"America/Chicago"`
- Cosmetic doc updates: `AGENTS.md`, `modules/core/AGENTS.md`,
  `modules/desktop/hyprland/lua/monitors.lua` comment, `README.md`
- AGENTS.md "TIMEZONE BUG" advisory line removed (bug fixed)

## What still needs to happen — per host

On **each** of the 4 machines, run **once** from a terminal with sudo:

```bash
sudo nixos-rebuild switch --flake "$HOME/NixOS#<NewHostName>"
```

Replace `<NewHostName>` with the new name for the machine you're on:
- On Station-Alpha → `sudo nixos-rebuild switch --flake "$HOME/NixOS#Hekate"`
- On Station-00    → `sudo nixos-rebuild switch --flake "$HOME/NixOS#Janus"`
- On Subrelay-01   → `sudo nixos-rebuild switch --flake "$HOME/NixOS#Medea"`
- On Scout-02      → `sudo nixos-rebuild switch --flake "$HOME/NixOS#Somnus"`

### Why the manual `nixos-rebuild` and not `rebuild`?

The `rebuild` script (at `modules/scripts/rebuild.nix`) bakes `${host}` into
the binary at Nix build time. The currently-installed `rebuild` binary on
each machine still has the **old** hostname baked in — it would pass
`--flake "$flake#Station-Alpha"` (or whichever old name) and fail to find
the flake output.

Running `nixos-rebuild switch --flake ".#NewName"` manually **once** builds
and activates the new system generation, which includes a new `rebuild`
binary with the new name baked in. After that, the regular `rebuild`
command works as before.

### Order

Any order is fine — the hosts are independent. There are no cross-host
references in the config. Each machine only needs its own rebuild.

### Verification (optional, read-only)

After edits but before rebuilding, you can sanity-check the flake without
activating anything:

```bash
nix eval --impure .#nixosConfigurations.Hekate.config.networking.hostName
# → "Hekate"

nix eval --impure .#nixosConfigurations.Janus.config.networking.hostName
# → "Janus"

nix eval --impure .#nixosConfigurations.Medea.config.networking.hostName
# → "Medea"

nix eval --impure .#nixosConfigurations.Somnus.config.networking.hostName
# → "Somnus"
```

This is read-only — it doesn't build a system or activate anything. Safe
to run from an agent session if desired.

## After all 4 hosts are rebuilt

This file can be removed once all 4 machines have been bootstrapped onto
the new names. Verify by running `rebuild` on each machine and confirming
the Host: line in its output matches the new name.

## Out of scope (not changed)

- Games logic bug at `hosts/Janus/configuration.nix:63` (inverted
  `vars.games == false` check) — still outstanding, not touched in this rename
- Headless-ing the two laptops (Medea, Somnus) — deferred to a separate
  role-out decision; this rename is purely cosmetic
- README "use Default as template" documentation philosophy — the
  mechanical `hosts/Default/` → `hosts/Janus/` text replacement was done,
  but `Janus` is now a *specific* machine, not a generic template. The
  "to add a host, copy X" instructions may want a separate docs cleanup
  session to rethink what the new template story is.

## Reference

- Naming scheme rationale: codemem decision entry "Host Naming Convention: Roman Esoteric Pantheon"
- Pre-existing safety rule: codemem #93 / #144 (agent never runs live rebuilds)
- Boundary check rule: codemem #277 (NEVER run nixos-rebuild — user does all rebuilds)