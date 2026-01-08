# MCP Wrapper Implementation Plan

## Overview

Build a custom MCP server that wraps Hindsight's REST API as MCP tools, providing immediate access to `retain`, `recall`, and `reflect`
## Architecture

```
LLM (Claude/GPT) → MCP Protocol (SSE) → MCP Wrapper → HTTP/REST → Hindsight Container
```

## Project Structure

```
hindsight-mcp/
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── requirements.txt
└── src/
    └── mcp_server.py
```

## Implementation Details

### 1. File: `src/mcp_server.py`

Create FastMCP server with 3 tools:

- **`hindsight_retain`** - Store memories (wraps `/v1/default/banks/{bank_id}/memories`)
- **`hindsight_recall`** - Search memories (wraps `/v1/default/banks/{bank_id}/memories/recall`)
- **`hindsight_reflect`** - Generate contextual answers (wraps `/v1/default/banks/{bank_id}/reflect`)

### 2. Tool Descriptions

Copy exact descriptions from existing `/home/player00/NixOS/dev-shells/python/hindsight-mcp/IMPLEMENTATION_PLAN.md` to ensure tools function identically to what the MCP server would provide.

### 3. Configuration

Environment variable for configuration:

```bash
HINDSIGHT_URL=http://hindsight:8888
```

### 4. Docker Setup

**Dockerfile:**
```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/mcp_server.py /app/mcp_server.py

# Environment variables
ENV HINDSIGHT_URL=http://hindsight:8888
ENV HINDSIGHT_DEFAULT_BANK_ID=Sisyphus

EXPOSE 8000

CMD ["python", "-m", "mcp_server"]
```

**docker-compose.yml:**
```yaml
services:
  hindsight-mcp-wrapper:
    build: .
    container_name: hindsight-mcp-wrapper
    ports:
      - "8000:8000"
    env_file:
      - .env
    restart: unless-stopped

```

### 5. Requirements.txt

```
fastmcp>=0.3.0
httpx>=0.27.0
python-dotenv>=1.0.0
```

## Implementation Steps

### Step 1: Create Project Structure

```bash
mkdir -p hindsight-mcp/src
cd hindsight-mcp
```

### Step 2: Create requirements.txt

```bash
cat > requirements.txt << 'EOF'
fastmcp>=0.3.0
httpx>=0.27.0
python-dotenv>=1.0.0
EOF
```

### Step 3: Create .env.example

```bash
cat > .env << 'EOF'
# Hindsight REST API URL (adjust if running on different host/port)
HINDSIGHT_URL=http://hindsight:8888
EOF
```

### Step 4: Create Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY src/mcp_server.py /app/mcp_server.py

# Environment variables
ENV HINDSIGHT_URL=http://hindsight:8888

# Expose MCP server port
EXPOSE 8000

# Run the MCP server
CMD ["python", "-m", "mcp_server"]
EOF
```

### Step 5: Create docker-compose.yml

```bash
cat > docker-compose.yml << 'EOF'

services:
  hindsight-mcp-wrapper:
    build: .
    container_name: hindsight-mcp-wrapper
    ports:
      - "8000:8000"
    env_file:
      - .env
    restart: unless-stopped

EOF
```

### Step 6: Create src/mcp_server.py

**Important:** This is the core implementation file.

```python
"""
Hindsight MCP Wrapper Server

Provides MCP tools that proxy to Hindsight REST API:
- hindsight_retain: Store memories
- hindsight_recall: Search memories
- hindsight_reflect: Generate contextual answers

Environment Variables:
- HINDSIGHT_URL: URL of Hindsight REST API (default: http://hindsight:8888)

"""

import os
import json
from typing import Optional
from dotenv import load_dotenv

from fastmcp import FastMCP
import httpx

# Load environment variables
load_dotenv()

HINDSIGHT_URL = os.environ.get("HINDSIGHT_URL", "http://hindsight:8888")

# Create MCP server
mcp = FastMCP("hindsight-mcp-wrapper")


@mcp.tool()
async def hindsight_retain(
    content: str,
    context: str = "general",
    bank_id: Optional[str] = None
) -> str:
    """Store important information to long-term memory.
    
    Use this tool PROACTIVELY whenever user shares:
    - Personal facts, preferences, or interests
    - Important events or milestones
    - User history, experiences, or background
    - Decisions, opinions, or stated preferences
    - Goals, plans, or future intentions
    - Relationships or people mentioned
    - Work context, projects, or responsibilities
    
    Args:
        content: The fact/memory to store (be specific and include relevant details)
        context: Category for the memory (e.g., 'preferences', 'work', 'hobbies', 'family'). Default: 'general'
        bank_id: Optional bank ID to target. If not provided, uses HINDSIGHT_DEFAULT_BANK_ID from environment.
    
    Returns:
        Success/error message
    """
    # Determine target bank
    target_bank = bank_id or DEFAULT_BANK_ID
    
    # Build REST API URL
    url = f"{HINDSIGHT_URL}/v1/default/banks/{target_bank}/memories"
    
    # Prepare headers
    headers = {}
    if HINDSIGHT_API_KEY:
        headers["Authorization"] = f"Bearer {HINDSIGHT_API_KEY}"
    
    # Make HTTP request to Hindsight
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                url,
                json={"items": [{"content": content, "context": context}]},
                headers=headers
            )
            response.raise_for_status()
            result = response.json()
            
            if result.get("success"):
                return "Memory stored successfully"
            else:
                return f"Error: {result.get('message', 'Unknown error')}"
    except httpx.HTTPStatusError as e:
        return f"HTTP Error {e.response.status_code}: {e.response.text}"
    except Exception as e:
        return f"Error: {str(e)}"


@mcp.tool()
async def hindsight_recall(
    query: str,
    max_results: int = 10,
    bank_id: Optional[str] = None
) -> str:
    """Search memories to provide personalized, context-aware responses.
    
    Use this tool PROACTIVELY to:
    - Check user's preferences before making suggestions
    - Recall user's history to provide continuity
    - Remember user's goals and context
    - Personalize responses based on past interactions
    
    Args:
        query: Natural language search query (e.g., "user's food preferences", "what projects is user working on")
        max_results: Maximum number of results to return (default: 10)
        bank_id: Optional bank ID to target. If not provided, uses HINDSIGHT_DEFAULT_BANK_ID from environment.
    
    Returns:
        JSON string with results array
    """
    target_bank = bank_id or DEFAULT_BANK_ID
    url = f"{HINDSIGHT_URL}/v1/default/banks/{target_bank}/memories/recall"
    
    headers = {}
    if HINDSIGHT_API_KEY:
        headers["Authorization"] = f"Bearer {HINDSIGHT_API_KEY}"
    
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                url,
                json={"query": query, "max_results": max_results},
                headers=headers
            )
            response.raise_for_status()
            result = response.json()
            return json.dumps({"results": result.get("results", [])})
    except httpx.HTTPStatusError as e:
        return json.dumps({"error": f"HTTP Error {e.response.status_code}: {e.response.text}"})
    except Exception as e:
        return json.dumps({"error": str(e)})


@mcp.tool()
async def hindsight_reflect(
    query: str,
    context: Optional[str] = None,
    budget: str = "low",
    bank_id: Optional[str] = None
) -> str:
    """Reflect and formulate an answer using bank identity, world facts, and opinions.
    
    This endpoint:
    1. Retrieves experience (conversations and events)
    2. Retrieves world facts relevant to query
    3. Retrieves existing opinions (bank's perspectives)
    4. Uses LLM to formulate a contextual answer
    5. Extracts and stores any new opinions formed
    6. Returns plain text answer, facts used, and new opinions
    
    Args:
        query: Natural language query/question to reflect on
        context: Additional context for the reflection
        budget: Search budget level - "low", "mid", or "high" (default: "low")
        bank_id: Optional bank ID to target. If not provided, uses HINDSIGHT_DEFAULT_BANK_ID from environment.
    
    Returns:
        Plain text answer from Hindsight
    """
    target_bank = bank_id or DEFAULT_BANK_ID
    url = f"{HINDSIGHT_URL}/v1/default/banks/{target_bank}/reflect"
    
    headers = {}
    if HINDSIGHT_API_KEY:
        headers["Authorization"] = f"Bearer {HINDSIGHT_API_KEY}"
    
    payload = {"query": query, "budget": budget}
    if context is not None:
        payload["context"] = context
    
    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(url, json=payload, headers=headers)
            response.raise_for_status()
            result = response.json()
            return result.get("text", "")
    except httpx.HTTPStatusError as e:
        return f"HTTP Error {e.response.status_code}: {e.response.text}"
    except Exception as e:
        return f"Error: {str(e)}"


if __name__ == "__main__":
    import sys
    # Run MCP server
    mcp.run()
```

## Testing

### Test Connection

```bash
# Build and start
docker compose up -d --build

# Check logs
docker compose logs -f hindsight-mcp-wrapper

### Direct Python Testing

```bash
# Install locally for quick testing
cd hindsight-mcp-wrapper
pip install -r requirements.txt

# Run directly
HINDSIGHT_URL=http://localhost:8888 python -m src.mcp_server
```

## Notes

1. **Error Handling:** All tools include try/except blocks to catch HTTP errors and return MCP-formatted error messages

2. **Timeout:** 30 second timeout for Hindsight REST API calls

3. **Tool Names:** Using `hindsight_` prefix to avoid naming conflicts if you add more tools later



