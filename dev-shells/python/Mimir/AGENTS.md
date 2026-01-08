# LightAgent Development Guidelines

## Build/Lint/Test Commands
- `uv pip install -e .` - Install package in editable mode
- `ruff check .` - Run linter (configured in pyproject.toml)
- `python -m pytest tests/` - Run tests (single test: `python -m pytest tests/test_file.py::test_function`)
- `python app.py` - Start the LightAgent service

## Code Style Guidelines
- **Imports**: Use absolute imports, group standard library → third-party → local
- **Formatting**: Follow PEP 8 with 4-space indentation, use ruff for linting
- **Types**: Annotate all functions with type hints
- **Naming**: snake_case for functions/variables, PascalCase for classes
- **Error Handling**: Use try/catch blocks with specific exceptions, return meaningful error messages
- **Logging**: Use loguru instead of print, respect logger configuration flags
- **Tools**: Define tool_info metadata for all tool functions with proper parameter schemas

## Project Overview
LightAgent: Production-level lightweight agentic AI framework with mem0, ACE, GAM integration. Currently in fluid development state with modular containerized architecture. Comprehensive documentation available in local markdown files covering setup, configuration, and examples.

## Development Environment
- Working directory /home/player00/NixOS/dev-shells/python/
- dev-shell handled automatically
- This environment is for building and working with python and the associated libs for the framework project
- Intended to operate with and alongside docker services for testing modular services.

## First Steps
- confirm python tools available
- confirm which libraries installed
- Determine whether containerized services are running and confirm with user whether or not running containers will be utilized.

## Service Integration
- Comprehensive setup docs in local markdown files (./documentation)
- Code examples and configuration guides available per service
- Modular configuration files separated by design where feasible and practical
- Each service has dedicated directory for Python libs and Docker configs

## GitHub Repository Navigation
- **ACE**: https://github.com/kayba-ai/agentic-context-engine
- **GAM**: https://github.com/VectorSpaceLab/general-agentic-memory  
- **Mem0**: https://github.com/mem0ai/mem0
- **LightAgent**: https://github.com/wanxingai/LightAgent
- **MANDATORY**: Use GitHub semantic search tools ONLY for repository navigation
- **PROHIBITED**: No other tools for GitHub repository navigation
- **COMPLEX REASONING**: Use deepwiki tool for inference tasks requiring multiple sources, will reference github repo and is supplementary to github repo analysis but does not itself navigate github repos.
- **OFFICIAL DOCS**: Use browsermcp tools, mem0 currently has the only official documentation outside of github.

## Configuration Architecture
- Modular design inspired by Nix configuration structure
- Service-specific configs with central coordination
- Directory: `/home/player00/NixOS/dev-shells/python/Mimir`
  - ex: `/home/player00/NixOS/dev-shells/python/Mimir/lightagent`
  - ex: `/home/player00/NixOS/dev-shells/python/Mimir/mem0`
- Hierarchical structure: individual service configs → service central config → primary config
- ALL service specific configurations and files should be organized neatly into their associated directory for each service as exampled above. ACE in agentic-context-engine/, LightAgent in lightagent/, etc.

## Deployment Context
- Containerized service operations with Docker Swarm deployment for local resource pooling
- Host-to-container communications and system integration
- Fluid development state with rapid container swapping experimentation
- End-state: permanent containers system-installed, devshell-integrated, or Docker Swarm deployed