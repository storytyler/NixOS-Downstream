from mem0 import Memory

import os

os.environ["OPENAI_API_KEY"] = "dummy"
os.environ["OPENAI_BASE_URL"] = "http://localhost:8000"

config = {
    "vector_store": {
        "provider": "pgvector",
        "config": {
            "user": "postgres",
            "password": "password",
            "host": "127.0.0.1",
            "port": 5432,
        }
    },
    "llm": {
        "provider": "openai",
        "config": {"model": "ibm/granite4:1b-h-q4_0", "temperature": 0.2}
    },
    "embedder": {
        "provider": "ollama",
        "config": {"model": "embeddinggemma:300m-qat-q4_0"},
    },
}

memory = Memory.from_config(config)
messages = [
    {"role": "user", "content": "I'm planning to watch a movie tonight. Any recommendations?"},
    {"role": "assistant", "content": "How about thriller movies? They can be quite engaging."},
    {"role": "user", "content": "I love thriller movies, especially psychological."},
    {"role": "assistant", "content": "Got it! I'll be sure to suggest thrillers of the psychological variety from now."}
]
result = memory.add(messages, user_id="player00", metadata={"category": "movies"})
print(result)
