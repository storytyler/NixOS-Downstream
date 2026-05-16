# Python Development Environment

Python 3.13 dev shell with hindsight-mcp (FastMCP server wrapping Hindsight REST API for persistent memory/retrieval).

## STRUCTURE
```
dev-shells/python/
├── hindsight-mcp/           # MCP server wrapping Hindsight REST API
│   ├── src/mcp_server.py   # FastMCP server (retain/recall/reflect tools)
│   ├── Dockerfile          # Python 3.12-slim container
│   └── docker-compose.yml  # Hindsight + MCP wrapper stack
├── documentation/           # Offline reference docs
├── .venv/                 # Python virtual environment
└── flake.nix              # Dev-shell: Python 3.13, pip, uv, ruff, black, basedpyright
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| MCP server | `hindsight-mcp/src/mcp_server.py` | FastMCP: retain, recall, reflect tools |
| Service docs | `documentation/` | Reference docs for upstream projects |

## COMMANDS
```bash
docker compose -f hindsight-mcp/docker-compose.yml up  # Start Hindsight stack
```
