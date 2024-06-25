import requests
import json

url = "http://localhost:8080/render"
params = {"schemaType": "CoA", "schemaVersion": "v1.1.0"}

with open("src/main/resources/schemas/CoA/v1.1.0/valid-cert.json", "r") as file:
    json_data = json.load(file)

json_data_str = json.dumps(json_data)

headers = {"Content-Type": "application/json"}

response = requests.post(url, params=params, data=json_data, headers=headers)

if response.status_code == 200:
    with open("output.pdf", "wb") as f:
        f.write(response.content)
    print("PDF saved as 'output.pdf'.")
else:
    print("Error:", response.status_code)
