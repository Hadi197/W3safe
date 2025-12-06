# WhatsApp Integration - Solusi Alternatif

## ❌ Masalah Sekarang: Evolution API v2.3.7 + Baileys
- QR scan ✅ berhasil  
- Status "Connected" ✅ tampil
- **Message sending ❌ GAGAL TOTAL** (timeout 30s+)
- Error: "error in sending keep alive" (Baileys WebSocket tidak stabil)
- Error: "Pre-key upload timeout"

## ✅ Solusi Rekomendasi: Meta WhatsApp Business Cloud API

### Kenapa Meta API?
1. **Official** - Langsung dari Meta/WhatsApp
2. **FREE** - 1000 pesan/bulan gratis
3. **Production-ready** - Stabil, tidak perlu QR scan
4. **Simple** - REST API standar, tidak perlu Docker
5. **Reliable** - Tidak ada masalah WebSocket/Baileys

### Setup Meta WhatsApp Business API

#### Step 1: Daftar & Get Credentials
1. Buka: https://developers.facebook.com/
2. Login dengan Facebook
3. Create App → Business → WhatsApp
4. Dapatkan:
   - Phone Number ID
   - WhatsApp Business Account ID
   - Access Token

#### Step 2: Test dengan cURL
```bash
curl -X POST \
  'https://graph.facebook.com/v18.0/YOUR_PHONE_NUMBER_ID/messages' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "messaging_product": "whatsapp",
    "to": "6285232364271",
    "type": "text",
    "text": {
      "body": "Test dari Meta WhatsApp API"
    }
  }'
```

#### Step 3: Python Integration
```python
import requests

def send_whatsapp(to: str, message: str):
    url = f"https://graph.facebook.com/v18.0/{PHONE_NUMBER_ID}/messages"
    headers = {
        "Authorization": f"Bearer {ACCESS_TOKEN}",
        "Content-Type": "application/json"
    }
    data = {
        "messaging_product": "whatsapp",
        "to": to,
        "type": "text",
        "text": {"body": message}
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()
```

#### Step 4: Vue/TypeScript Service
```typescript
// src/services/whatsapp/meta-api.service.ts
export class MetaWhatsAppService {
  private readonly baseURL = 'https://graph.facebook.com/v18.0'
  private readonly phoneNumberId = import.meta.env.VITE_WHATSAPP_PHONE_ID
  private readonly accessToken = import.meta.env.VITE_WHATSAPP_ACCESS_TOKEN

  async sendText(to: string, message: string) {
    const response = await fetch(`${this.baseURL}/${this.phoneNumberId}/messages`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.accessToken}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        messaging_product: 'whatsapp',
        to,
        type: 'text',
        text: { body: message }
      })
    })
    return response.json()
  }
}
```

### Fitur Meta API
- ✅ Text messages
- ✅ Images/Documents
- ✅ Templates (pre-approved messages)
- ✅ Buttons & Interactive messages
- ✅ Message status (sent/delivered/read)
- ✅ Webhooks untuk incoming messages

### Pricing
- **FREE**: 1000 pesan/bulan (cukup untuk app HSSE)
- **Paid**: Rp 200-500/pesan setelah limit free

---

## Alternatif Lain (Jika Tidak Mau Meta)

### Option 2: Evolution API v2.1.x (Downgrade)
```bash
# Build older stable version
git clone https://github.com/EvolutionAPI/evolution-api.git
cd evolution-api
git checkout 2.1.2  # Stable tag
docker build -t evolution-api:2.1.2 .
```

### Option 3: WA-Automate (Open source)
```bash
docker run -d \
  -p 3000:3000 \
  --name wa-automate \
  openwa/wa-automate
```

### Option 4: Commercial Services
- **Twilio WhatsApp** (1 cent/message)
- **MessageBird** 
- **Vonage**

---

## Rekomendasi Final

**Gunakan Meta WhatsApp Business Cloud API** karena:
1. ✅ No Docker needed (simpler deployment)
2. ✅ No QR scanning (user-friendly)
3. ✅ Reliable (Meta infrastructure)
4. ✅ Free tier cukup (1000 msg/month)
5. ✅ Official API (future-proof)

**Langkah selanjutnya:**
1. User daftar Meta for Developers
2. Create WhatsApp app
3. Get credentials (Phone ID + Access Token)
4. Agent implement Meta API service
5. Test message sending
6. Integrate ke HSSE workflows
