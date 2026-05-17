# Dev Shell Template Library

46 standalone Nix flake dev-shell templates for rapid project bootstrapping.

## STRUCTURE
```
dev-shells/
├── default.nix         # Registry: maps name → { path, description } + aliases
├── changeAll.sh        # Bulk nixpkgs URL swapper (FlakeHub ↔ github)
├── updateAll.sh        # Bulk nix flake update across all templates
├── python/             # FULL PROJECT (not template): hindsight-mcp
├── sandboxed-python/   # Docker-based sandbox (shell.nix, not flake)
└── [43 language dirs]  # Each: standalone flake.nix + flake.lock
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Use a shell | `nix develop -t .#<name>` | Or: `nix develop /path/to/NixOS/dev-shells/<name>` |
| Register new shell | Add entry to `default.nix` | Map name → path + description |
| Create new shell | Copy `empty/`, add packages | Every shell is standalone flake with own lockfile |
| Bulk update | `updateAll.sh` | Runs `nix flake update` in every subdirectory |
| Switch nixpkgs source | `changeAll.sh` | Swaps FlakeHub ↔ GitHub URLs |

## CONVENTIONS
- **Canonical pattern**: Every shell follows `empty/flake.nix` scaffold — `forEachSupportedSystem`, `mkShell`
- **4 platforms**: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin (except rocketnotes: Linux only)
- **Version pinning**: Single variable at top (e.g., `goVersion = 23`, `javaVersion = 23`, `version = "3.13"`)
- **Zero coupling**: Each shell has own `flake.lock` — no shared state
- **Aliases**: `c` → c-cpp, `cpp` → c-cpp, `rt` → rust-toolchain
- **Overlays**: Some shells (rust, go) define local overlays for version pinning

## KEY SHELLS

| Name | Key Packages | Notes |
|------|-------------|-------|
| python | Python 3.13, pip, uv, basedpyright, black, ruff | venvShellHook auto-creates .venv |
| rust / rust-toolchain | rustc, cargo, clippy, rust-analyzer | fenix overlay; rt reads rust-toolchain.toml |
| node | nodejs, yarn, pnpm, node2nix | |
| go | go 1.23, gotools, golangci-lint | Version via overlay |
| c-cpp | clang-tools, cmake, conan, gtest, vcpkg, gdb | |
| java | JDK 23, maven, gradle, lombok | Version via overlay |
| nix | nixd, cachix, lorri, niv, statix | |
| hashi | terraform, nomad, vault, terragrunt | Full HashiCorp stack |
| pulumi | pulumi-bin + Python/Go/Node/Java SDKs | Multi-language IaC |

## ANTI-PATTERNS
- DON'T add shared dependencies between shells — each is standalone by design
- DON'T use `python/` as a template — it's a full project with hindsight-mcp
- DON'T modify shells without running `nix flake check` afterward
