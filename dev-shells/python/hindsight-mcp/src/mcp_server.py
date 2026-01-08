"""
Hindsight MCP Wrapper Server

Provides MCP tools that proxy to Hindsight REST API:
- hindsight_retain: Store memories
- hindsight_recall: Search memories
- hindsight_reflect: Generate contextual answers

Environment Variables:
- HINDSIGHT_URL: URL of Hindsight REST API (default: http://hindsight:8888)
- HINDSIGHT_DEFAULT_BANK_ID: Default bank ID to use (default: Sisyphus)
- HINDSIGHT_API_KEY: Optional API key for authentication

"""

import os
import json
from typing import Optional
from dotenv import load_dotenv

from fastmcp import FastMCP
import httpx

load_dotenv()

HINDSIGHT_URL = os.environ.get("HINDSIGHT_URL", "http://hindsight:8888")
DEFAULT_BANK_ID = os.environ.get("HINDSIGHT_DEFAULT_BANK_ID", "Sisyphus")
HINDSIGHT_API_KEY = os.environ.get("HINDSIGHT_API_KEY")

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
    target_bank = bank_id or DEFAULT_BANK_ID
    url = f"{HINDSIGHT_URL}/v1/default/banks/{target_bank}/memories"

    headers = {}
    if HINDSIGHT_API_KEY:
        headers["Authorization"] = f"Bearer {HINDSIGHT_API_KEY}"

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
    mcp.run(transport="sse")
