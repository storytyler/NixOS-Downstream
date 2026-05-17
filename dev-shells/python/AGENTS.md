# Python Development Environment

Python 3.13 dev shell with hindsight-mcp (FastMCP server wrapping Hindsight REST API for persistent memory/retrieval).

## STRUCTURE
```
dev-shells/python/
├── hindsight-mcp/           # MCP server wrapping Hindsight REST API
│   ├── src/mcp_server.py   # FastMCP server (retain/recall/reflect tools)
│   ├── Dockerfile          # Python 3.12-slim container
│   └── docker-compose.yml  # Hindsight + MCP wrapper stack
├── documentation/           # Offline reference docs (17 files)
├── .venv/                 # Python virtual environment
└── flake.nix              # Dev-shell: Python 3.13, pip, uv, ruff, black, basedpyright
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| MCP server | `hindsight-mcp/src/mcp_server.py` | FastMCP: retain, recall, reflect tools |
| Service docs | `documentation/` | Reference docs for upstream projects |
| Dev shell config | `flake.nix` | Python 3.13, venvShellHook auto-creates .venv |

## CONVENTIONS
- Version pinned at top of `flake.nix`: `version = "3.13"`
- `venvShellHook` auto-creates `.venv` on shell entry
- Warning hook detects `.venv`/Python version mismatches

## COMMANDS
```bash
docker compose -f hindsight-mcp/docker-compose.yml up  # Start Hindsight stack
nix develop -t .#python                                  # Enter dev shell
```
