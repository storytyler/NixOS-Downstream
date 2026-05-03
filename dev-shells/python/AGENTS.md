# Python Development Environment

LightAgent framework: production-level AI framework with mem0, ACE, GAM integration. Modular containerized architecture in fluid development state.

## STRUCTURE
```
dev-shells/python/
├── Mimir/                  # Main framework project (integration hub)
│   ├── mem0/               # Memory service configs + integration scripts
│   ├── containers/         # Ollama wrapper + pgvector PostgreSQL
│   └── test_*.py           # Ad-hoc smoke tests (NOT pytest)
├── general-agentic-memory/  # GAM: dual-agent memory (MemoryAgent + ResearchAgent)
│   ├── gam/                # Core library (agents, generators, retrievers, schemas)
│   ├── eval/               # Benchmark scripts (HotpotQA, LoCoMo, RULER, NarrativeQA)
│   └── tests/              # Unit tests (TTL memory/page stores)
├── hindsight-mcp/           # MCP server wrapping Hindsight REST API
│   ├── src/mcp_server.py   # FastMCP server (retain/recall/reflect tools)
│   ├── Dockerfile          # Python 3.12-slim container
│   └── docker-compose.yml  # Hindsight + MCP wrapper stack
├── documentation/           # Offline reference docs (lightagent, mem0, ace, gam)
├── .venv/                 # Python virtual environment
└── flake.nix              # Dev-shell: Python 3.13, pip, uv, ruff, black, basedpyright
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Mem0 config | `Mimir/mem0/config-dictionary.py` | pgvector + Ollama embed + Gemini LLM + Flashrank |
| Ollama wrapper | `Mimir/containers/ollama/ollama-openai-wrapper.py` | FastAPI OpenAI-compat proxy |
| PostgreSQL | `Mimir/containers/pgsql/compose.yml` | pgvector/pgvector:pg17 |
| GAM library | `general-agentic-memory/gam/` | MemoryAgent, ResearchAgent, retrievers |
| GAM evals | `general-agentic-memory/eval/` | Benchmark scripts (NOT unit tests) |
| MCP server | `hindsight-mcp/src/mcp_server.py` | FastMCP: retain, recall, reflect tools |
| Service docs | `documentation/` | 17 markdown files for all upstream projects |

## CONVENTIONS
- Modular design: each service in dedicated directory with own configs
- Hierarchical: individual service configs → service central config → primary config
- `lightagent/` and `agentic-context-engine/` directories referenced but not yet on disk
- GAM has dual config (pyproject.toml + setup.py) — console_scripts entry `gam-eval=eval.run:main`

## ANTI-PATTERNS
- MANDATORY: Use GitHub semantic search tools for repository navigation
- PROHIBITED: No other tools for GitHub repo navigation
- COMPLEX REASONING: Use deepwiki tool for multi-source inference
- OFFICIAL DOCS: Use browsermcp tools (mem0 has only official docs outside GitHub)

## COMMANDS
```bash
uv pip install -e .              # Install package in editable mode
ruff check .                     # Run linter (default settings, no config file)
python -m pytest tests/           # Run GAM unit tests
python app.py                     # Start LightAgent service (app.py not yet on disk)
docker compose -f hindsight-mcp/docker-compose.yml up  # Start Hindsight stack
```

## SERVICES
- **Ollama**: Port 11434, embedding model: embeddinggemma-300m-qat-q4_0
- **PostgreSQL + pgvector**: Port 5432, compose: `Mimir/containers/pgsql/compose.yml`
- **Hindsight**: Ports 8888 (API), 9999 (Web UI), ghcr.io/vectorize-io/hindsight:0.1.15
- **Hindsight MCP**: Port 8000, SSE transport