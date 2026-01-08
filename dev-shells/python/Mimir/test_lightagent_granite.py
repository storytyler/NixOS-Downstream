from LightAgent import LightAgent

agent = LightAgent(model="ibm/granite4:1b-h-q4_0", api_key="None", base_url="http://localhost:8000/chat/completions")
response = agent.run("Hello, who are you?")
print(response)
