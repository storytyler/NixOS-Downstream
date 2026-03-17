# Python Development Environment

LightAgent framework: production-level AI framework with mem0, ACE, GAM integration. Modular containerized architecture in fluid development state.

## STRUCTURE
```
dev-shells/python/
├── Mimir/                  # Main framework project
│   ├── lightagent/          # LightAgent service
│   ├── mem0/               # Memory service
│   └── agentic-context-engine/  # Context engine (ACE)
├── general-agentic-memory/  # GAM integration
├── documentation/           # Setup and config docs
├── .venv/                 # Python virtual environment
└── pyproject.toml          # Python project configuration
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| LightAgent config | `dev-shells/python/Mimir/lightagent/` | Main framework service |
| Memory service | `dev-shells/python/Mimir/mem0/` | Memory management |
| Context engine | `dev-shells/python/Mimir/agentic-context-engine/` | Context handling |
| Service docs | `dev-shells/python/documentation/` | Setup guides |
| GAM integration | `dev-shells/python/general-agentic-memory/` | Vector memory |

## CONVENTIONS
- Modular design inspired by Nix configuration structure
- Service-specific configs with central coordination
- Hierarchical: individual service configs → service central config → primary config
- ALL service files organized in dedicated directories (lightagent/, mem0/, etc.)

## ANTI-PATTERNS
- MANDATORY: Use GitHub semantic search tools for repository navigation
- PROHIBITED: No other tools for GitHub repo navigation
- COMPLEX REASONING: Use deepwiki tool for multi-source inference
- OFFICIAL DOCS: Use browsermcp tools (mem0 has only official docs outside GitHub)

## COMMANDS
```bash
uv pip install -e .    # Install package in editable mode
ruff check .            # Run linter (configured in pyproject.toml)
python -m pytest tests/  # Run tests
python app.py           # Start LightAgent service
```

## SERVICES
- **Ollama embedding**: Port 11434, model: embeddinggemma-300m-qat-q4_0
- **Flashrank reranking**: Smallest model available
- **PostgreSQL + pgvector**: Port 5432, local files: `Mimir/containers/pgsql/`