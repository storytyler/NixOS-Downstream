import requests
from concurrent.futures import ThreadPoolExecutor

url = "http://localhost:11434/api/generate"

def ask_question(question):
    data = {
        "model": "ibm/granite4:1b-h-q4_0",
        "prompt": question,
        "stream": False
    }
    response = requests.post(url, json=data)
    result = response.json()
    return question, result['response']

questions = [
    "If I have 5 apples and eat 2, then buy 3 more, how many apples do I have?",
    "Which is larger, the Earth or the Moon?",
    "If today is Monday, what day will it be in 7 days?"
]

with ThreadPoolExecutor(max_workers=3) as executor:
    results = list(executor.map(ask_question, questions))

for question, answer in results:
    print(f"Q: {question}\nA: {answer}\n")
