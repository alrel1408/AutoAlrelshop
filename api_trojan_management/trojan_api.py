#!/usr/bin/env python3
"""
Trojan Account Management API
Berdasarkan script m-trojan dari AlrelShop Auto Script

API ini menyediakan endpoint untuk mengelola akun Trojan:
- CREATE: Membuat akun trojan baru
- TRIAL: Membuat akun trial trojan
- DELETE: Menghapus akun trojan
- RENEW: Memperpanjang akun trojan
- LIST: Melihat daftar akun trojan
- CHECK: Mengecek status login akun trojan
- DETAIL: Melihat detail konfigurasi akun
"""

from flask import Flask, request, jsonify
import subprocess
import json
import os
import re
import uuid
from datetime import datetime, timedelta
import logging

app = Flask(__name__)

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class TrojanManager:
    def __init__(self):
        self.config_path = "/etc/xray/config.json"
        self.trojan_db_path = "/etc/trojan/.trojan.db"
        self.domain = self._get_domain()
        self.bot_config = self._get_bot_config()
        
    def _get_domain(self):
        """Mendapatkan domain dari konfigurasi"""
        try:
            with open("/etc/xray/domain", "r") as f:
                return f.read().strip()
        except:
            return "example.com"
    
    def _get_bot_config(self):
        """Mendapatkan konfigurasi bot telegram"""
        try:
            with open("/etc/bot/.bot.db", "r") as f:
                for line in f:
                    if line.startswith("#bot# "):
                        parts = line.strip().split(" ")
                        return {"key": parts[1], "chat_id": parts[2]}
        except:
            pass
        return {"key": "", "chat_id": ""}
    
    def _run_command(self, command):
        """Menjalankan command sistem"""
        try:
            result = subprocess.run(command, shell=True, capture_output=True, text=True)
            return result.returncode == 0, result.stdout, result.stderr
        except Exception as e:
            return False, "", str(e)
    
    def _generate_uuid(self):
        """Generate UUID untuk password trojan"""
        return str(uuid.uuid4())
    
    def _check_user_exists(self, username):
        """Cek apakah username sudah ada"""
        success, output, _ = self._run_command(f"grep -w {username} {self.config_path} | wc -l")
        if success:
            return int(output.strip()) > 0
        return False
    
    def _get_exp_date(self, days):
        """Mendapatkan tanggal expired"""
        exp_date = datetime.now() + timedelta(days=days)
        return exp_date.strftime("%Y-%m-%d")
    
    def _add_to_xray_config(self, username, password, exp_date):
        """Menambahkan user ke konfigurasi xray"""
        # Add to trojanws section
        cmd1 = f"""sed -i '/#trojanws$/a\\#! {username} {exp_date}\\
}},{{"password": "{password}","email": "{username}"' {self.config_path}"""
        
        # Add to trojangrpc section  
        cmd2 = f"""sed -i '/#trojangrpc$/a\\#!# {username} {exp_date}\\
}},{{"password": "{password}","email": "{username}"' {self.config_path}"""
        
        self._run_command(cmd1)
        self._run_command(cmd2)
        
    def _remove_from_xray_config(self, username, exp_date):
        """Menghapus user dari konfigurasi xray"""
        cmd1 = f"sed -i '/^#! {username} {exp_date}/,/^}},{{/d' {self.config_path}"
        cmd2 = f"sed -i '/^#!# {username} {exp_date}/,/^}},{{/d' {self.config_path}"
        
        self._run_command(cmd1)
        self._run_command(cmd2)
    
    def _restart_services(self):
        """Restart layanan yang diperlukan"""
        self._run_command("systemctl restart xray")
        self._run_command("systemctl reload nginx")
        self._run_command("service cron restart")
    
    def _setup_limits(self, username, quota_gb, ip_limit):
        """Setup quota dan IP limit untuk user"""
        # Setup IP limit
        if ip_limit > 0:
            self._run_command(f"mkdir -p /etc/kyt/limit/trojan/ip")
            self._run_command(f"echo '{ip_limit}' > /etc/kyt/limit/trojan/ip/{username}")
        
        # Setup quota limit
        if quota_gb and quota_gb > 0:
            self._run_command("mkdir -p /etc/trojan")
            quota_bytes = quota_gb * 1024 * 1024 * 1024
            self._run_command(f"echo '{quota_bytes}' > /etc/trojan/{username}")
    
    def _update_trojan_db(self, username, exp_date, password, quota, ip_limit):
        """Update database trojan"""
        # Remove existing entry
        self._run_command(f"sed -i '/\\b{username}\\b/d' {self.trojan_db_path}")
        
        # Add new entry
        self._run_command(f"echo '### {username} {exp_date} {password} {quota} {ip_limit}' >> {self.trojan_db_path}")
    
    def _generate_links(self, username, password):
        """Generate link trojan"""
        domain = self.domain
        
        # Trojan WS TLS
        trojan_ws = f"trojan://{password}@{domain}:443?path=%2Ftrojan-ws&security=tls&host={domain}&type=ws&sni={domain}#{username}"
        
        # Trojan WS Non-TLS
        trojan_ws_ntls = f"trojan://{password}@{domain}:80?path=%2Ftrojan-ws&security=none&host={domain}&type=ws#{username}"
        
        # Trojan gRPC
        trojan_grpc = f"trojan://{password}@{domain}:443?mode=gun&security=tls&type=grpc&serviceName=trojan-grpc&sni={domain}#{username}"
        
        return {
            "ws_tls": trojan_ws,
            "ws_ntls": trojan_ws_ntls,
            "grpc": trojan_grpc
        }
    
    def _create_config_file(self, username, password, quota, ip_limit):
        """Membuat file konfigurasi untuk OpenClash"""
        domain = self.domain
        
        config_content = f"""---------------------------------------------------
# Format Trojan GO/WS
---------------------------------------------------
proxies:
  - name: Trojan-{username}-GO/WS
    server: {domain}
    port: 443
    type: trojan
    password: {password}
    skip-cert-verify: true
    sni: {domain}
    network: ws
    ws-opts:
      path: /trojan-ws
      headers:
        Host: {domain}
    udp: true

---------------------------------------------------    
# Format Trojan gRPC
---------------------------------------------------
- name: Trojan-{username}-gRPC
  type: trojan
  server: {domain}
  port: 443
  password: {password}
  udp: true
  sni: {domain}
  skip-cert-verify: true
  network: grpc
  grpc-opts:
    grpc-service-name: trojan-grpc

◇━━━━━━━━━━━━━━━━━◇
   Trojan Account
◇━━━━━━━━━━━━━━━━━◇
Remarks          : {username}
Domain           : {domain}
User Quota       : {quota} GB
User Ip          : {ip_limit} IP
Port TLS         : 400-900
Port none TLS    : 80, 8080, 8081-9999
id               : {password}
alterId          : 0
Security         : auto
Network          : ws
Path             : /trojan-ws
ServiceName      : trojan-grpc
"""
        
        # Save config file
        config_path = f"/var/www/html/trojan-{username}.txt"
        with open(config_path, "w") as f:
            f.write(config_content)
        
        return config_path

    def create_account(self, username, days, quota_gb, ip_limit):
        """Membuat akun trojan baru"""
        try:
            # Validasi input
            if not username or not re.match(r'^[a-zA-Z0-9_]+$', username):
                return False, "Username tidak valid. Gunakan huruf, angka, dan underscore saja."
            
            if self._check_user_exists(username):
                return False, "Username sudah ada."
            
            if days <= 0:
                return False, "Durasi harus lebih dari 0 hari."
            
            # Generate password dan tanggal expired
            password = self._generate_uuid()
            exp_date = self._get_exp_date(days)
            
            # Tambahkan ke konfigurasi xray
            self._add_to_xray_config(username, password, exp_date)
            
            # Setup limits
            self._setup_limits(username, quota_gb, ip_limit)
            
            # Update database
            self._update_trojan_db(username, exp_date, password, quota_gb, ip_limit)
            
            # Restart services
            self._restart_services()
            
            # Generate links
            links = self._generate_links(username, password)
            
            # Create config file
            config_file = self._create_config_file(username, password, quota_gb, ip_limit)
            
            return True, {
                "username": username,
                "password": password,
                "expired": exp_date,
                "quota_gb": quota_gb,
                "ip_limit": ip_limit,
                "domain": self.domain,
                "links": links,
                "config_url": f"https://{self.domain}:81/trojan-{username}.txt",
                "qr_code": f"https://api.qrserver.com/v1/create-qr-code/?size=400x400&data={links['ws_tls']}"
            }
            
        except Exception as e:
            logger.error(f"Error creating account: {str(e)}")
            return False, f"Error: {str(e)}"
    
    def create_trial(self):
        """Membuat akun trial trojan"""
        try:
            # Generate random trial username
            random_num = str(uuid.uuid4())[:8]
            username = f"Trial-{random_num}"
            
            return self.create_account(username, 1, 1, 3)  # 1 hari, 1GB, 3 IP
            
        except Exception as e:
            logger.error(f"Error creating trial: {str(e)}")
            return False, f"Error: {str(e)}"
    
    def delete_account(self, username):
        """Menghapus akun trojan"""
        try:
            if not self._check_user_exists(username):
                return False, "Username tidak ditemukan."
            
            # Get expiry date
            success, output, _ = self._run_command(f"grep -wE '^#! {username}' {self.config_path} | cut -d ' ' -f 3 | sort | uniq")
            if not success:
                return False, "Gagal mendapatkan data user."
            
            exp_date = output.strip()
            
            # Remove from xray config
            self._remove_from_xray_config(username, exp_date)
            
            # Remove from database
            self._run_command(f"sed -i '/^### {username} {exp_date}/,/^}},{{/d' {self.trojan_db_path}")
            
            # Remove quota and IP limit files
            self._run_command(f"rm -rf /etc/trojan/{username}")
            self._run_command(f"rm -rf /etc/kyt/limit/trojan/ip/{username}")
            
            # Remove config file
            self._run_command(f"rm -rf /var/www/html/trojan-{username}.txt")
            
            # Restart services
            self._restart_services()
            
            return True, f"Akun {username} berhasil dihapus."
            
        except Exception as e:
            logger.error(f"Error deleting account: {str(e)}")
            return False, f"Error: {str(e)}"
    
    def renew_account(self, username, days, quota_gb=None, ip_limit=None):
        """Memperpanjang akun trojan"""
        try:
            if not self._check_user_exists(username):
                return False, "Username tidak ditemukan."
            
            # Remove existing limits
            self._run_command(f"rm -f /etc/kyt/limit/trojan/ip/{username}")
            self._run_command(f"rm -f /etc/trojan/{username}")
            
            # Get current expiry date
            success, output, _ = self._run_command(f"grep -wE '^#! {username}' {self.config_path} | cut -d ' ' -f 3 | sort | uniq")
            if not success:
                return False, "Gagal mendapatkan data user."
            
            old_exp = output.strip()
            
            # Calculate new expiry date
            new_exp = self._get_exp_date(days)
            
            # Update config
            self._run_command(f"sed -i '/^#! {username}/c\\#! {username} {new_exp}' {self.config_path}")
            
            # Setup new limits if provided
            if quota_gb is not None:
                self._setup_limits(username, quota_gb, ip_limit or 1)
            
            # Restart services
            self._restart_services()
            
            return True, {
                "username": username,
                "new_expiry": new_exp,
                "quota_gb": quota_gb,
                "ip_limit": ip_limit
            }
            
        except Exception as e:
            logger.error(f"Error renewing account: {str(e)}")
            return False, f"Error: {str(e)}"
    
    def list_accounts(self):
        """Melihat daftar akun trojan"""
        try:
            success, output, _ = self._run_command(f"grep -E '^#! ' {self.config_path} | cut -d ' ' -f 2-3")
            if not success:
                return False, "Gagal mengambil data akun."
            
            accounts = []
            for line in output.strip().split('\n'):
                if line:
                    parts = line.split()
                    if len(parts) >= 2:
                        accounts.append({
                            "username": parts[0],
                            "expired": parts[1]
                        })
            
            return True, accounts
            
        except Exception as e:
            logger.error(f"Error listing accounts: {str(e)}")
            return False, f"Error: {str(e)}"
    
    def check_login(self, username):
        """Mengecek status login akun"""
        try:
            if not self._check_user_exists(username):
                return False, "Username tidak ditemukan."
            
            # Get login info from log
            success, output, _ = self._run_command(f"cat /var/log/xray/access.log | grep -w '{username}' | tail -n 500 | cut -d ' ' -f 2 | tail -1")
            last_login = output.strip() if success else "Belum pernah login"
            
            # Get IP usage
            success, output, _ = self._run_command(f"cat /var/log/xray/access.log | grep -w '{username}' | tail -n 500 | cut -d ' ' -f 3 | sed 's/tcp://g' | cut -d ':' -f 1 | sort | uniq | wc -l")
            ip_count = int(output.strip()) if success else 0
            
            # Get limits
            success, quota_output, _ = self._run_command(f"cat /etc/trojan/{username} 2>/dev/null")
            quota_bytes = int(quota_output.strip()) if success and quota_output.strip() else 0
            quota_gb = quota_bytes / (1024 * 1024 * 1024) if quota_bytes > 0 else 0
            
            success, ip_limit_output, _ = self._run_command(f"cat /etc/kyt/limit/trojan/ip/{username} 2>/dev/null")
            ip_limit = int(ip_limit_output.strip()) if success and ip_limit_output.strip() else 0
            
            return True, {
                "username": username,
                "last_login": last_login,
                "ip_count": ip_count,
                "ip_limit": ip_limit,
                "quota_gb": quota_gb
            }
            
        except Exception as e:
            logger.error(f"Error checking login: {str(e)}")
            return False, f"Error: {str(e)}"

# Initialize manager
trojan_manager = TrojanManager()

# API Endpoints
@app.route('/api/trojan/create', methods=['POST'])
def create_trojan_account():
    """
    Endpoint untuk membuat akun trojan baru
    
    JSON Body:
    {
        "username": "user123",
        "days": 30,
        "quota_gb": 10,
        "ip_limit": 2
    }
    """
    try:
        data = request.get_json()
        
        username = data.get('username')
        days = int(data.get('days', 30))
        quota_gb = int(data.get('quota_gb', 0))
        ip_limit = int(data.get('ip_limit', 1))
        
        success, result = trojan_manager.create_account(username, days, quota_gb, ip_limit)
        
        if success:
            return jsonify({
                "status": "success",
                "message": "Akun trojan berhasil dibuat",
                "data": result
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Invalid request: {str(e)}"
        }), 400

@app.route('/api/trojan/trial', methods=['POST'])
def create_trial_account():
    """
    Endpoint untuk membuat akun trial trojan
    
    Response:
    {
        "status": "success",
        "data": {...}
    }
    """
    try:
        success, result = trojan_manager.create_trial()
        
        if success:
            return jsonify({
                "status": "success",
                "message": "Akun trial trojan berhasil dibuat",
                "data": result
            }), 200
        else:
            return jsonify({
                "status": "error", 
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/delete', methods=['DELETE'])
def delete_trojan_account():
    """
    Endpoint untuk menghapus akun trojan
    
    JSON Body:
    {
        "username": "user123"
    }
    """
    try:
        data = request.get_json()
        username = data.get('username')
        
        if not username:
            return jsonify({
                "status": "error",
                "message": "Username wajib diisi"
            }), 400
        
        success, result = trojan_manager.delete_account(username)
        
        if success:
            return jsonify({
                "status": "success",
                "message": result
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/renew', methods=['PUT'])
def renew_trojan_account():
    """
    Endpoint untuk memperpanjang akun trojan
    
    JSON Body:
    {
        "username": "user123",
        "days": 30,
        "quota_gb": 10,
        "ip_limit": 2
    }
    """
    try:
        data = request.get_json()
        
        username = data.get('username')
        days = int(data.get('days', 30))
        quota_gb = data.get('quota_gb')
        ip_limit = data.get('ip_limit')
        
        if not username:
            return jsonify({
                "status": "error",
                "message": "Username wajib diisi"
            }), 400
        
        if quota_gb is not None:
            quota_gb = int(quota_gb)
        if ip_limit is not None:
            ip_limit = int(ip_limit)
        
        success, result = trojan_manager.renew_account(username, days, quota_gb, ip_limit)
        
        if success:
            return jsonify({
                "status": "success",
                "message": "Akun berhasil diperpanjang",
                "data": result
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/list', methods=['GET'])
def list_trojan_accounts():
    """
    Endpoint untuk melihat daftar semua akun trojan
    
    Response:
    {
        "status": "success",
        "data": [
            {
                "username": "user123",
                "expired": "2024-01-15"
            }
        ]
    }
    """
    try:
        success, result = trojan_manager.list_accounts()
        
        if success:
            return jsonify({
                "status": "success",
                "message": f"Ditemukan {len(result)} akun trojan",
                "data": result
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/check/<username>', methods=['GET'])
def check_trojan_login(username):
    """
    Endpoint untuk mengecek status login akun trojan
    
    Response:
    {
        "status": "success",
        "data": {
            "username": "user123",
            "last_login": "2024-01-01 10:30:45",
            "ip_count": 2,
            "ip_limit": 2,
            "quota_gb": 10
        }
    }
    """
    try:
        success, result = trojan_manager.check_login(username)
        
        if success:
            return jsonify({
                "status": "success",
                "data": result
            }), 200
        else:
            return jsonify({
                "status": "error",
                "message": result
            }), 400
            
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/config/<username>', methods=['GET'])
def get_trojan_config(username):
    """
    Endpoint untuk mendapatkan konfigurasi trojan untuk username tertentu
    """
    try:
        config_path = f"/var/www/html/trojan-{username}.txt"
        
        if not os.path.exists(config_path):
            return jsonify({
                "status": "error",
                "message": "Konfigurasi tidak ditemukan"
            }), 404
        
        with open(config_path, 'r') as f:
            config_content = f.read()
        
        return jsonify({
            "status": "success",
            "data": {
                "username": username,
                "config": config_content,
                "config_url": f"https://{trojan_manager.domain}:81/trojan-{username}.txt"
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": f"Error: {str(e)}"
        }), 500

@app.route('/api/trojan/info', methods=['GET'])
def get_server_info():
    """
    Endpoint untuk mendapatkan informasi server
    """
    try:
        return jsonify({
            "status": "success",
            "data": {
                "domain": trojan_manager.domain,
                "api_version": "1.0",
                "description": "Trojan Account Management API - AlrelShop Auto Script"
            }
        }), 200
        
    except Exception as e:
        return jsonify({
            "status": "error", 
            "message": f"Error: {str(e)}"
        }), 500

@app.errorhandler(404)
def not_found(error):
    return jsonify({
        "status": "error",
        "message": "Endpoint tidak ditemukan"
    }), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({
        "status": "error",
        "message": "Internal server error"
    }), 500

if __name__ == '__main__':
    print("🚀 Trojan Management API Server")
    print("📡 Berdasarkan script m-trojan AlrelShop Auto Script")
    print("🔗 Endpoints tersedia:")
    print("   POST   /api/trojan/create     - Buat akun trojan")
    print("   POST   /api/trojan/trial      - Buat akun trial") 
    print("   DELETE /api/trojan/delete     - Hapus akun trojan")
    print("   PUT    /api/trojan/renew      - Perpanjang akun trojan")
    print("   GET    /api/trojan/list       - Daftar semua akun")
    print("   GET    /api/trojan/check/<username> - Cek status login")
    print("   GET    /api/trojan/config/<username> - Ambil konfigurasi")
    print("   GET    /api/trojan/info       - Info server")
    print("")
    
    app.run(host='0.0.0.0', port=5000, debug=True)
