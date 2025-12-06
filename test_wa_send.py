import requests
import json

API_URL = "http://localhost:8080"
API_KEY = "your-strong-api-key-change-this"
INSTANCE = "hsse-wa-fresh"

def send_message(phone, text):
    url = f"{API_URL}/message/sendText/{INSTANCE}"
    headers = {
        "apikey": API_KEY,
        "Content-Type": "application/json"
    }
    data = {
        "number": phone,
        "text": text
    }
    
    try:
        print(f"📤 Sending message to {phone}...")
        response = requests.post(url, headers=headers, json=data, timeout=30)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.text}")
        return response.json()
    except Exception as e:
        print(f"❌ Error: {e}")
        return None

if __name__ == "__main__":
    result = send_message(
        "6285232364271",
        "✅ Test WhatsApp dari HSSE App\n\nSistem notifikasi K3L aktif!"
    )
    print("\nResult:", json.dumps(result, indent=2))
