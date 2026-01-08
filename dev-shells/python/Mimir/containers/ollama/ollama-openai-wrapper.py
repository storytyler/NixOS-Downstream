from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Optional
import httpx
import uvicorn

app = FastAPI(title="Ollama OpenAI v1 API Wrapper")

OLLAMA_BASE_URL = "http://localhost:11434"


class Message(BaseModel):
    role: str
    content: str


class ChatCompletionRequest(BaseModel):
    model: str
    messages: List[Message]
    temperature: Optional[float] = 0.7
    max_tokens: Optional[int] = None
    stream: Optional[bool] = False


class ChatCompletionResponse(BaseModel):
    id: str
    object: str = "chat.completion"
    created: int
    model: str
    choices: List[dict]
    usage: dict


def convert_openai_to_ollama(request: ChatCompletionRequest) -> dict:
    ollama_messages = [
        {"role": msg.role, "content": msg.content} for msg in request.messages
    ]
    
    ollama_request = {
        "model": request.model,
        "messages": ollama_messages,
        "stream": request.stream,
    }
    
    if request.temperature is not None:
        ollama_request["options"] = {"temperature": request.temperature}
    
    if request.max_tokens is not None:
        if "options" not in ollama_request:
            ollama_request["options"] = {}
        ollama_request["options"]["num_predict"] = request.max_tokens
    
    return ollama_request


def convert_ollama_to_openai(ollama_response: dict, model: str) -> dict:
    import time
    
    return {
        "id": f"chatcmpl-{int(time.time() * 1000)}",
        "object": "chat.completion",
        "created": int(time.time()),
        "model": model,
        "choices": [
            {
                "index": 0,
                "message": {
                    "role": ollama_response.get("message", {}).get("role", "assistant"),
                    "content": ollama_response.get("message", {}).get("content", ""),
                },
                "finish_reason": ollama_response.get("done_reason", "stop"),
            }
        ],
        "usage": {
            "prompt_tokens": ollama_response.get("prompt_eval_count", 0),
            "completion_tokens": ollama_response.get("eval_count", 0),
            "total_tokens": ollama_response.get("prompt_eval_count", 0) + ollama_response.get("eval_count", 0),
        },
    }


@app.post("/v1/chat/completions")
@app.post("/chat/completions")
async def chat_completions(request: ChatCompletionRequest):
    try:
        ollama_request = convert_openai_to_ollama(request)
        
        async with httpx.AsyncClient(timeout=60.0) as client:
            response = await client.post(
                f"{OLLAMA_BASE_URL}/api/chat",
                json=ollama_request,
            )
            response.raise_for_status()
            ollama_response = response.json()
        
        openai_response = convert_ollama_to_openai(ollama_response, request.model)
        
        return ChatCompletionResponse(**openai_response)
    
    except httpx.HTTPError as e:
        raise HTTPException(status_code=500, detail=f"Ollama API error: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal error: {str(e)}")


@app.get("/v1/models")
async def list_models():
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get(f"{OLLAMA_BASE_URL}/api/tags")
            response.raise_for_status()
            ollama_response = response.json()
        
        models = []
        for model in ollama_response.get("models", []):
            models.append({
                "id": model["name"],
                "object": "model",
                "created": model.get("modified_at", 0),
                "owned_by": "ollama",
            })
        
        return {
            "object": "list",
            "data": models,
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to list models: {str(e)}")


@app.get("/health")
async def health_check():
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            response = await client.get(f"{OLLAMA_BASE_URL}/api/tags")
            response.raise_for_status()
        
        return {"status": "healthy", "ollama_connected": True}
    except Exception as e:
        return {"status": "unhealthy", "ollama_connected": False, "error": str(e)}


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
