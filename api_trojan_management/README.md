# Trojan Account Management API

API untuk mengelola akun Trojan berdasarkan script `m-trojan` dari AlrelShop Auto Script.

## 📋 Fitur

- ✅ **CREATE** - Membuat akun trojan baru
- ✅ **TRIAL** - Membuat akun trial trojan (1 hari, 1GB, 3 IP)
- ✅ **DELETE** - Menghapus akun trojan
- ✅ **RENEW** - Memperpanjang akun trojan
- ✅ **LIST** - Melihat daftar semua akun trojan
- ✅ **CHECK** - Mengecek status login akun
- ✅ **CONFIG** - Mendapatkan konfigurasi OpenClash
- ✅ **INFO** - Informasi server

## 🚀 Installation

1. **Install dependencies:**
```bash
pip install -r requirements.txt
```

2. **Jalankan API server:**
```bash
python trojan_api.py
```

3. **API akan berjalan di:**
```
http://localhost:5000
```

## 📡 API Endpoints

### 1. CREATE Account
**POST** `/api/trojan/create`

Membuat akun trojan baru.

**Request Body:**
```json
{
    "username": "user123",
    "days": 30,
    "quota_gb": 10,
    "ip_limit": 2
}
```

**Response:**
```json
{
    "status": "success",
    "message": "Akun trojan berhasil dibuat",
    "data": {
        "username": "user123",
        "password": "xxxx-xxxx-xxxx-xxxx",
        "expired": "2024-02-15",
        "quota_gb": 10,
        "ip_limit": 2,
        "domain": "example.com",
        "links": {
            "ws_tls": "trojan://xxxx@example.com:443?path=%2Ftrojan-ws&security=tls&host=example.com&type=ws&sni=example.com#user123",
            "ws_ntls": "trojan://xxxx@example.com:80?path=%2Ftrojan-ws&security=none&host=example.com&type=ws#user123",
            "grpc": "trojan://xxxx@example.com:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni=example.com#user123"
        },
        "config_url": "https://example.com:81/trojan-user123.txt",
        "qr_code": "https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=..."
    }
}
```

### 2. TRIAL Account
**POST** `/api/trojan/trial`

Membuat akun trial trojan (otomatis: 1 hari, 1GB, 3 IP).

**Response:**
```json
{
    "status": "success",
    "message": "Akun trial trojan berhasil dibuat",
    "data": {
        "username": "Trial-xxxxxxxx",
        "password": "xxxx-xxxx-xxxx-xxxx",
        "expired": "2024-01-17",
        "quota_gb": 1,
        "ip_limit": 3,
        "links": {...},
        "config_url": "...",
        "qr_code": "..."
    }
}
```

### 3. DELETE Account
**DELETE** `/api/trojan/delete`

Menghapus akun trojan.

**Request Body:**
```json
{
    "username": "user123"
}
```

**Response:**
```json
{
    "status": "success",
    "message": "Akun user123 berhasil dihapus"
}
```

### 4. RENEW Account
**PUT** `/api/trojan/renew`

Memperpanjang akun trojan.

**Request Body:**
```json
{
    "username": "user123",
    "days": 30,
    "quota_gb": 15,
    "ip_limit": 3
}
```

**Response:**
```json
{
    "status": "success",
    "message": "Akun berhasil diperpanjang",
    "data": {
        "username": "user123",
        "new_expiry": "2024-02-15",
        "quota_gb": 15,
        "ip_limit": 3
    }
}
```

### 5. LIST Accounts
**GET** `/api/trojan/list`

Melihat daftar semua akun trojan.

**Response:**
```json
{
    "status": "success",
    "message": "Ditemukan 5 akun trojan",
    "data": [
        {
            "username": "user123",
            "expired": "2024-02-15"
        },
        {
            "username": "user456",
            "expired": "2024-01-30"
        }
    ]
}
```

### 6. CHECK Login Status
**GET** `/api/trojan/check/{username}`

Mengecek status login akun trojan.

**Response:**
```json
{
    "status": "success",
    "data": {
        "username": "user123",
        "last_login": "2024-01-16 10:30:45",
        "ip_count": 2,
        "ip_limit": 2,
        "quota_gb": 10
    }
}
```

### 7. GET Config
**GET** `/api/trojan/config/{username}`

Mendapatkan konfigurasi OpenClash untuk username tertentu.

**Response:**
```json
{
    "status": "success",
    "data": {
        "username": "user123",
        "config": "---------------------------------------------------\n# Format Trojan GO/WS\n...",
        "config_url": "https://example.com:81/trojan-user123.txt"
    }
}
```

### 8. SERVER Info
**GET** `/api/trojan/info`

Mendapatkan informasi server.

**Response:**
```json
{
    "status": "success",
    "data": {
        "domain": "example.com",
        "api_version": "1.0",
        "description": "Trojan Account Management API - AlrelShop Auto Script"
    }
}
```

## 🧪 Testing dengan cURL

### Create Account
```bash
curl -X POST http://localhost:5000/api/trojan/create \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "days": 30,
    "quota_gb": 10,
    "ip_limit": 2
  }'
```

### Create Trial
```bash
curl -X POST http://localhost:5000/api/trojan/trial
```

### List Accounts
```bash
curl -X GET http://localhost:5000/api/trojan/list
```

### Check Account
```bash
curl -X GET http://localhost:5000/api/trojan/check/testuser
```

### Delete Account
```bash
curl -X DELETE http://localhost:5000/api/trojan/delete \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser"}'
```

### Renew Account
```bash
curl -X PUT http://localhost:5000/api/trojan/renew \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "days": 30,
    "quota_gb": 15,
    "ip_limit": 3
  }'
```

## 📝 Response Format

Semua endpoint mengembalikan response dalam format JSON:

**Success Response:**
```json
{
    "status": "success",
    "message": "...",
    "data": {...}
}
```

**Error Response:**
```json
{
    "status": "error",
    "message": "Error message"
}
```

## 🔧 Konfigurasi

API ini menggunakan file-file konfigurasi berikut:
- `/etc/xray/config.json` - Konfigurasi Xray
- `/etc/xray/domain` - Domain server
- `/etc/trojan/.trojan.db` - Database akun trojan
- `/etc/bot/.bot.db` - Konfigurasi bot telegram
- `/etc/kyt/limit/trojan/ip/` - Limit IP per user
- `/etc/trojan/` - Quota per user

## ⚠️ Requirements

Pastikan sistem sudah memiliki:
- ✅ Xray sudah terinstall dan terkonfigurasi
- ✅ File konfigurasi trojan sudah ada
- ✅ Directory `/var/www/html/` dapat ditulis
- ✅ Python 3.6+
- ✅ Flask

## 🛡️ Security

- API ini didesain untuk dijalankan di server internal
- Untuk production, tambahkan authentication/authorization
- Gunakan HTTPS untuk komunikasi yang aman
- Batasi akses hanya untuk IP terpercaya

## 📞 Support

API ini dibuat berdasarkan script `m-trojan` dari **AlrelShop Auto Script**. Untuk pertanyaan atau bantuan, silakan merujuk ke dokumentasi asli atau komunitas AlrelShop.
