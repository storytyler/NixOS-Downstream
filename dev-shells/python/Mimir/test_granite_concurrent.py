import requests
from concurrent.futures import ThreadPoolExecutor

url = "http://localhost:11434/api/generate"

def ask_question(question):
    data = {
        "model": "ibm/granite4:1b-h-q4_0",
        "prompt": f"{question} Answer with only yes or no.",
        "stream": False
    }
    response = requests.post(url, json=data)
    result = response.json()
    return question, result['response']

questions = [
    "Is the sky blue?",
    "Do humans need oxygen?",
    "Is the sun a planet?"
]

with ThreadPoolExecutor(max_workers=3) as executor:
    results = list(executor.map(ask_question, questions))

for question, answer in results:
    print(f"Q: {question}\nA: {answer}\n")
