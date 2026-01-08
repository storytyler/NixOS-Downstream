import os
from mem0 import Memory

os.environ["OPENAI_API_KEY"] = "sk-xx"

config = {
    "vector_store": {
        "provider": "pgvector",
        "config": {
            "user": "postgres",
            "password": "password",
            "host": "127.0.0.1",
            "port": "5432",
        }
    }
}

m = Memory.from_config(config)
messages = [
    {"role": "user", "content": "I'm planning to watch a movie tonight. Any recommendations?"},
    {"role": "assistant", "content": "How about thriller movies? They can be quite engaging."},
    {"role": "user", "content": "I love thriller movies, especially psychological."},
    {"role": "assistant", "content": "Got it! I'll be sure to suggest thrillers of the psychological variety from now."}
]
m.add(messages, user_id="player00", metadata={"category": "movies"})