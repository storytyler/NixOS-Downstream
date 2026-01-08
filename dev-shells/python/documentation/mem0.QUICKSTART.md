Installation
1
Install SDK


pip

npm
pip install mem0ai
2
Set your API key


Python

JavaScript

cURL
from mem0 import MemoryClient

client = MemoryClient(api_key="your-api-key")
3
Add a memory


Python

JavaScript

cURL
messages = [
    {"role": "user", "content": "I'm a vegetarian and allergic to nuts."},
    {"role": "assistant", "content": "Got it! I'll remember your dietary preferences."}
]
client.add(messages, user_id="user123")
4
Search memories


Python

JavaScript

cURL
results = client.search("What are my dietary restrictions?", filters={"user_id": "user123"})
print(results)
Output:
{
  "results": [
    {
      "id": "14e1b28a-2014-40ad-ac42-69c9ef42193d",
      "memory": "Allergic to nuts",
      "user_id": "user123",
      "categories": ["health"],
      "created_at": "2025-10-22T04:40:22.864647-07:00",
      "score": 0.30
    }
  ]
}
​
