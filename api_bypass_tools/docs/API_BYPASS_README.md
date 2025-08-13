# API Rate Limit Bypass Scripts

Collection of scripts untuk bypass rate limit API dengan berbagai teknik.

## 🚀 Features

- **API Key Rotation**: Menggunakan multiple API keys secara bergiliran
- **User Agent Rotation**: Mengganti user agent secara random
- **Proxy Support**: Mendukung rotasi proxy untuk bypass IP limit
- **Intelligent Delays**: Delay otomatis dengan randomization
- **Retry Logic**: Auto retry dengan exponential backoff
- **Batch Processing**: Process multiple requests dengan optimal timing

## 📁 Files

- `api_bypass.py` - Python script (paling lengkap)
- `api_bypass.php` - PHP script (mudah digunakan)
- `api_bypass.sh` - Bash script (untuk Linux/Unix)
- `bypass_config.json` - File konfigurasi
- `API_BYPASS_README.md` - Panduan ini

## ⚙️ Setup

### 1. Python Version

```bash
# Install dependencies
pip install requests

# Edit konfigurasi
nano api_bypass.py
# Tambahkan API keys Anda di array self.api_keys
```

### 2. PHP Version

```bash
# Pastikan PHP curl extension aktif
php -m | grep curl

# Edit konfigurasi
nano api_bypass.php
# Tambahkan API keys Anda di array $apiKeys
```

### 3. Bash Version

```bash
# Install dependencies (jika belum ada)
sudo apt-get install curl bc

# Make executable
chmod +x api_bypass.sh

# Edit konfigurasi
nano api_bypass.sh
# Tambahkan API keys di array API_KEYS
```

## 🎯 Usage

### Python

```python
from api_bypass import APIBypass

bypass = APIBypass()

# Single request
result = bypass.make_request("https://api.example.com/data")

# Batch requests
urls = ["https://api.example.com/data1", "https://api.example.com/data2"]
results = bypass.batch_requests(urls)

# POST request
data = {"key": "value"}
result = bypass.make_request("https://api.example.com/create", "POST", data)
```

### PHP

```php
require 'api_bypass.php';

$bypass = new APIBypass();

// Single request
$result = $bypass->makeRequest("https://api.example.com/data");

// Batch requests  
$urls = ["https://api.example.com/data1", "https://api.example.com/data2"];
$results = $bypass->batchRequests($urls);

// POST request
$data = ["key" => "value"];
$result = $bypass->makeRequest("https://api.example.com/create", "POST", $data);
```

### Bash

```bash
# Single request
./api_bypass.sh single "https://api.example.com/data" GET

# Batch requests (buat file urls.txt dulu)
echo -e "https://api.example.com/data1\nhttps://api.example.com/data2" > urls.txt
./api_bypass.sh batch urls.txt 3

# Test connection
./api_bypass.sh test
```

## 🔧 Advanced Configuration

### 1. Multiple API Keys

Tambahkan semua API keys yang Anda miliki:

```python
self.api_keys = [
    "sk-1234567890abcdef",
    "sk-abcdef1234567890", 
    "sk-9876543210fedcba",
    # Tambahkan sebanyak mungkin
]
```

### 2. Proxy Setup

Jika Anda memiliki proxy:

```python
self.proxies_list = [
    {"http": "http://user:pass@proxy1:8080", "https": "https://user:pass@proxy1:8080"},
    {"http": "http://user:pass@proxy2:8080", "https": "https://user:pass@proxy2:8080"},
]
```

### 3. Custom Headers

Untuk API yang memerlukan header khusus:

```python
headers = {
    "X-Custom-Header": "value",
    "X-Client-ID": "your_client_id", 
    "X-Requested-With": "XMLHttpRequest"
}
```

## 🛡️ Bypass Techniques

### 1. API Key Rotation
- Menggunakan multiple API keys secara bergiliran
- Mencegah single key dari rate limit

### 2. User Agent Rotation  
- Mengganti user agent setiap request
- Meniru browser yang berbeda-beda

### 3. IP Rotation via Proxy
- Menggunakan proxy untuk ganti IP
- Bypass IP-based rate limiting

### 4. Request Timing
- Delay random antar request
- Exponential backoff saat error

### 5. Session Management
- Menggunakan cookies untuk maintain session
- Reuse connection untuk efisiensi

## ⚠️ Important Notes

1. **Rate Limit Respect**: Jangan terlalu agresif, respect server
2. **API Terms**: Pastikan tidak melanggar ToS API
3. **Legal Use**: Gunakan hanya untuk keperluan legal
4. **Error Handling**: Selalu handle error dengan baik
5. **Monitoring**: Monitor success rate dan adjust parameter

## 🔄 Error Handling

Script akan handle berbagai error:

- **429 Too Many Requests**: Auto retry dengan delay
- **Connection Timeout**: Retry dengan proxy lain
- **Invalid API Key**: Switch ke key berikutnya
- **Server Error**: Exponential backoff

## 📊 Monitoring

Untuk monitoring success rate:

```python
# Check stats
stats = bypass.get_stats()
print(f"Success rate: {stats['success_rate']}%")
print(f"Total requests: {stats['total_requests']}")
```

## 🚨 Troubleshooting

### API Key Issues
```bash
# Test single API key
curl -H "Authorization: Bearer YOUR_KEY" https://api.example.com/test
```

### Proxy Issues
```bash
# Test proxy
curl --proxy http://proxy:port https://httpbin.org/ip
```

### Rate Limit Testing
```bash
# Check current limits
curl -I https://api.example.com/endpoint
# Look for X-RateLimit-* headers
```

## 📝 Example Workflows

### 1. Data Scraping
```python
# Scrape multiple endpoints
endpoints = ["/users", "/posts", "/comments"]
base_url = "https://api.example.com"

for endpoint in endpoints:
    url = base_url + endpoint
    data = bypass.make_request(url)
    save_to_file(f"data{endpoint.replace('/', '_')}.json", data)
```

### 2. Bulk Operations
```python
# Create multiple resources
items = [{"name": f"Item {i}"} for i in range(100)]

for item in items:
    result = bypass.make_request(
        "https://api.example.com/items", 
        "POST", 
        item
    )
    print(f"Created: {result.get('id')}")
```

Semoga membantu! 🎉
