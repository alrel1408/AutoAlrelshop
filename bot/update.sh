#!/bin/bash

echo "========== MULAI PROSES UPDATE =========="

# Direktori kerja sementara
TEMP_DIR="/tmp/update_vvip"
TARGET_DIR="/root/bot"  # Ubah sesuai lokasi bot kamu di VPS

# Hapus folder sementara lama jika ada
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "📦 Mengunduh file dari GitHub..."
wget -q -O bot.zip https://github.com/xyzval/VVIP/archive/refs/heads/main.zip

echo "📂 Mengekstrak file ZIP..."
unzip -o -qq bot.zip

echo "📁 Menyalin file ke direktori tujuan..."
cp -r VVIP-main/bot/* "$TARGET_DIR"

echo "🧹 Membersihkan file sementara..."
rm -rf "$TEMP_DIR"

echo "✅ Update selesai. Silakan cek bot Anda."

# (Opsional) Restart bot jika kamu pakai systemd
# systemctl restart bot.service
