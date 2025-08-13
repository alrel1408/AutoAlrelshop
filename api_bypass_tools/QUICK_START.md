# 🚀 Quick Start Guide

Panduan cepat untuk mulai menggunakan API Bypass Tools.

## 📦 Instalasi Cepat

```bash
# 1. Masuk ke direktori tools
cd api_bypass_tools/

# 2. Jalankan setup otomatis
python setup.py

# 3. Edit konfigurasi dengan API keys Anda
# Edit file: config/user_config.json
```

## ⚡ Test Cepat

### Python
```bash
cd python/
python test_bypass.py
```

### PHP  
```bash
cd php/
php api_bypass.php
```

### Bash
```bash
cd bash/
./api_bypass.sh test
```

## 🎯 Penggunaan Dasar

### 1. Single Request
```python
from api_bypass import APIBypass

bypass = APIBypass()
result = bypass.make_request("https://api.example.com/data")
print(result)
```

### 2. Batch Requests
```python
urls = [
    "https://api.example.com/data1",
    "https://api.example.com/data2", 
    "https://api.example.com/data3"
]

results = bypass.batch_requests(urls)
```

### 3. POST Request
```python
data = {"key": "value", "action": "create"}
result = bypass.make_request(
    "https://api.example.com/create", 
    "POST", 
    data
)
```

## ⚙️ Konfigurasi API Keys

Edit file `config/user_config.json`:

```json
{
  "api_keys": [
    "your_api_key_1", 
    "your_api_key_2",
    "your_api_key_3"
  ]
}
```

## 🛡️ Fitur Bypass

✅ **Auto Retry** - Retry otomatis saat rate limit
✅ **Key Rotation** - Ganti API key otomatis  
✅ **Smart Delays** - Delay optimal antar request
✅ **User Agent Rotation** - Random user agent
✅ **Proxy Support** - Rotasi IP via proxy

## 📋 Error yang Diatasi

- `429 Too Many Requests` → Auto retry dengan delay
- `Connection Timeout` → Retry dengan proxy lain
- `Invalid API Key` → Switch ke key berikutnya
- `Server Error 5xx` → Exponential backoff

## 🔧 Customization

### Custom Headers
```python
bypass = APIBypass()
# Tambah header khusus di class
```

### Custom Delays
```json
{
  "settings": {
    "min_delay": 2,
    "max_retries": 5,
    "rate_limit_wait": 90
  }
}
```

### Proxy Setup
```json
{
  "proxies": [
    {"http": "http://proxy1:8080"},
    {"http": "http://proxy2:8080"}
  ]
}
```

## 📚 Contoh untuk API Populer

Lihat folder `examples/api_examples/`:
- `openai_example.py` - OpenAI/ChatGPT API
- `github_example.py` - GitHub API

## ⚠️ Important Notes

1. **Respect Rate Limits** - Jangan spam API
2. **Legal Use Only** - Untuk development/testing
3. **API ToS** - Pastikan tidak melanggar ToS
4. **Monitor Usage** - Track success rate

## 🆘 Troubleshooting

### API Key Error
```bash
# Test manual
curl -H "Authorization: Bearer YOUR_KEY" https://api.example.com/test
```

### Proxy Issues  
```bash
# Test proxy
curl --proxy http://proxy:port https://httpbin.org/ip
```

### Rate Limit Debug
```python
# Check headers untuk rate limit info
response = requests.get(url)
print(response.headers)
```

---

**Happy Bypassing! 🎉**

Untuk dokumentasi lengkap: `docs/API_BYPASS_README.md`
