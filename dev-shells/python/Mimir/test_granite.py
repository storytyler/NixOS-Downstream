import requests
import json

url = "http://localhost:11434/api/generate"
data = {
    "model": "ibm/granite4:1b-h-q4_0",
    "prompt": "Is the sky blue? Answer with only yes or no.",
    "stream": False
}

response = requests.post(url, json=data)
result = response.json()
print(result['response'])
