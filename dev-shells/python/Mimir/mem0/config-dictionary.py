from mem0 import Memory

config = {
    "vector_store": {
        "provider": "pgvector",
        "config": {"host": "localhost", "port": 5432},
    },
    "llm": {
        "provider": "google",
        "config": {"model": "gemini-3-flash", "temperature": 0.1},
    },
    "embedder": {
        "provider": "ollama",
        "config": {"model": "embeddinggemma-300m-qat-q4_0"},
    },
    "reranker": {
        "provider": "ollama",
        "config": {"model": "rerank-english-v3.0"},
    },
}

memory = Memory.from_config(config)