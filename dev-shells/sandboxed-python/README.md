# Sandboxed Python Development Environment

A Docker-based, easily reproducible sandboxed Python environment.

## Quick Start

```bash
# Run sandbox in current directory
docker-sandbox-python

# Or specify a project directory
docker-sandbox-python /path/to/project

# Run with a specific Python version
docker-sandbox-python --python=3.11

# Run with GPU support (for ML workloads)
docker-sandbox-python --gpu
```

## What's Included

- Python 3.13 (or specified version)
- pip, uv, poetry (package managers)
- git, vim, curl (basic tools)
- black, ruff, basedpyright (linting/formatting)
- jupyter (optional, via --jupyter flag)

## How It Works

1. Docker container with isolated filesystem
2. Your project directory mounted at `/workspace`
3. All changes isolated to the container
4. Reproducible - same image everywhere

## Persisting State

The container is ephemeral (changes don't persist after exit), but you can:

```bash
# Keep container running for multiple sessions
docker-sandbox-python --keep

# Mount a cache directory for pip/packages
docker-sandbox-python --cache=/home/user/.cache/pip
```

## Security

- Container runs as non-root user
- No access to host filesystem except mounted workspace
- Network access available (can be disabled with `--offline`)
- No Docker socket access (safer than privileged containers)

## Building Your Own

```bash
# Build the image locally
docker build -t my-python-sandbox .

# Use custom image
docker-sandbox-python --image=my-python-sandbox
```

## Comparison to Nix dev-shells

| Feature | Nix dev-shell | Docker Sandbox |
|---------|---------------|----------------|
| Reproducibility | Perfect (exact derivations) | Good (pinned images) |
| Isolation | Process-level | Container-level |
| Startup Time | Instant | ~1-2 seconds |
| Ease of Use | Needs Nix knowledge | Familiar Docker workflow |
| Customization | Nix language | Dockerfile |

Use this when you need:
- Quick sandboxing without Nix complexity
- Running untrusted code
- Easy sharing with non-Nix users
- Docker ecosystem integration
