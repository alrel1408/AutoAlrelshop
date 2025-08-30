#!/bin/bash

# Trojan Management API Startup Script
# Berdasarkan script m-trojan AlrelShop Auto Script

echo "🚀 Starting Trojan Management API Server..."
echo "📡 Berdasarkan script m-trojan AlrelShop Auto Script"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 tidak ditemukan. Install Python3 terlebih dahulu."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 tidak ditemukan. Install pip3 terlebih dahulu."
    exit 1
fi

# Install requirements
echo "📦 Installing requirements..."
pip3 install -r requirements.txt

# Check if required directories exist
echo "🔍 Checking system requirements..."

REQUIRED_DIRS=(
    "/etc/xray"
    "/etc/trojan"
    "/etc/kyt/limit/trojan/ip"
    "/var/www/html"
    "/etc/bot"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "⚠️  Directory $dir tidak ditemukan, membuat directory..."
        mkdir -p "$dir"
    fi
done

# Check if required files exist
REQUIRED_FILES=(
    "/etc/xray/config.json"
    "/etc/xray/domain"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  File $file tidak ditemukan."
        if [[ "$file" == "/etc/xray/domain" ]]; then
            echo "📝 Membuat file domain default..."
            echo "example.com" > /etc/xray/domain
        fi
    fi
done

# Create trojan database if not exists
if [ ! -f "/etc/trojan/.trojan.db" ]; then
    echo "📝 Membuat database trojan..."
    touch /etc/trojan/.trojan.db
fi

# Create bot config if not exists
if [ ! -f "/etc/bot/.bot.db" ]; then
    echo "📝 Membuat konfigurasi bot default..."
    mkdir -p /etc/bot
    echo "#bot# dummy_key dummy_chat_id" > /etc/bot/.bot.db
fi

# Set permissions
echo "🔐 Setting permissions..."
chmod +x trojan_api.py
chmod +x test_api.py

echo ""
echo "✅ Setup completed!"
echo ""
echo "🚀 Starting API server on http://0.0.0.0:5000"
echo "📖 Lihat dokumentasi lengkap di README.md"
echo "🧪 Test API dengan: python3 test_api.py"
echo ""

# Start the API server
python3 trojan_api.py
