#!/usr/bin/env python3
"""
Test script untuk Trojan Management API
Script untuk testing semua endpoint yang tersedia
"""

import requests
import json
import time

# Configuration
API_BASE_URL = "http://localhost:5000"
TEST_USERNAME = "testapi123"

def print_response(response, title="Response"):
    """Print formatted response"""
    print(f"\n{'='*50}")
    print(f"📡 {title}")
    print(f"{'='*50}")
    print(f"Status Code: {response.status_code}")
    
    try:
        data = response.json()
        print(f"Response: {json.dumps(data, indent=2, ensure_ascii=False)}")
    except:
        print(f"Response: {response.text}")
    print(f"{'='*50}")

def test_server_info():
    """Test server info endpoint"""
    print("\n🔍 Testing Server Info...")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/trojan/info")
        print_response(response, "Server Info")
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_create_account():
    """Test create account endpoint"""
    print("\n✨ Testing Create Account...")
    
    try:
        data = {
            "username": TEST_USERNAME,
            "days": 30,
            "quota_gb": 10,
            "ip_limit": 2
        }
        
        response = requests.post(
            f"{API_BASE_URL}/api/trojan/create",
            json=data,
            headers={"Content-Type": "application/json"}
        )
        
        print_response(response, "Create Account")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_create_trial():
    """Test create trial endpoint"""
    print("\n🎯 Testing Create Trial...")
    
    try:
        response = requests.post(f"{API_BASE_URL}/api/trojan/trial")
        print_response(response, "Create Trial")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_list_accounts():
    """Test list accounts endpoint"""
    print("\n📋 Testing List Accounts...")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/trojan/list")
        print_response(response, "List Accounts")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_check_account():
    """Test check account endpoint"""
    print("\n🔎 Testing Check Account...")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/trojan/check/{TEST_USERNAME}")
        print_response(response, "Check Account")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_get_config():
    """Test get config endpoint"""
    print("\n⚙️ Testing Get Config...")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/trojan/config/{TEST_USERNAME}")
        print_response(response, "Get Config")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_renew_account():
    """Test renew account endpoint"""
    print("\n🔄 Testing Renew Account...")
    
    try:
        data = {
            "username": TEST_USERNAME,
            "days": 60,
            "quota_gb": 20,
            "ip_limit": 3
        }
        
        response = requests.put(
            f"{API_BASE_URL}/api/trojan/renew",
            json=data,
            headers={"Content-Type": "application/json"}
        )
        
        print_response(response, "Renew Account")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_delete_account():
    """Test delete account endpoint"""
    print("\n🗑️ Testing Delete Account...")
    
    try:
        data = {
            "username": TEST_USERNAME
        }
        
        response = requests.delete(
            f"{API_BASE_URL}/api/trojan/delete",
            json=data,
            headers={"Content-Type": "application/json"}
        )
        
        print_response(response, "Delete Account")
        return response.status_code == 200
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def test_invalid_endpoint():
    """Test invalid endpoint"""
    print("\n❌ Testing Invalid Endpoint...")
    
    try:
        response = requests.get(f"{API_BASE_URL}/api/trojan/invalid")
        print_response(response, "Invalid Endpoint")
        return response.status_code == 404
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def run_all_tests():
    """Run all tests"""
    print("🚀 TROJAN MANAGEMENT API TESTING")
    print("=" * 60)
    print(f"🔗 Base URL: {API_BASE_URL}")
    print(f"👤 Test Username: {TEST_USERNAME}")
    
    tests = [
        ("Server Info", test_server_info),
        ("Create Account", test_create_account),
        ("Create Trial", test_create_trial), 
        ("List Accounts", test_list_accounts),
        ("Check Account", test_check_account),
        ("Get Config", test_get_config),
        ("Renew Account", test_renew_account),
        ("Delete Account", test_delete_account),
        ("Invalid Endpoint", test_invalid_endpoint)
    ]
    
    results = []
    
    for test_name, test_func in tests:
        try:
            result = test_func()
            results.append((test_name, "✅ PASS" if result else "❌ FAIL"))
            time.sleep(1)  # Small delay between tests
        except Exception as e:
            results.append((test_name, f"❌ ERROR: {e}"))
    
    # Print summary
    print("\n" + "=" * 60)
    print("📊 TEST SUMMARY")
    print("=" * 60)
    
    passed = 0
    for test_name, status in results:
        print(f"{status:12} | {test_name}")
        if "PASS" in status:
            passed += 1
    
    print("=" * 60)
    print(f"✅ Passed: {passed}/{len(results)}")
    print(f"❌ Failed: {len(results) - passed}/{len(results)}")
    
    if passed == len(results):
        print("🎉 ALL TESTS PASSED!")
    else:
        print("⚠️ Some tests failed. Check the API server.")

def interactive_test():
    """Interactive testing mode"""
    print("🎮 INTERACTIVE TESTING MODE")
    print("=" * 40)
    
    while True:
        print("\nPilih test yang ingin dijalankan:")
        print("1. Server Info")
        print("2. Create Account") 
        print("3. Create Trial")
        print("4. List Accounts")
        print("5. Check Account")
        print("6. Get Config")
        print("7. Renew Account")
        print("8. Delete Account")
        print("9. Run All Tests")
        print("0. Exit")
        
        choice = input("\nMasukkan pilihan (0-9): ").strip()
        
        if choice == "0":
            print("👋 Goodbye!")
            break
        elif choice == "1":
            test_server_info()
        elif choice == "2":
            test_create_account()
        elif choice == "3":
            test_create_trial()
        elif choice == "4":
            test_list_accounts()
        elif choice == "5":
            test_check_account()
        elif choice == "6":
            test_get_config()
        elif choice == "7":
            test_renew_account()
        elif choice == "8":
            test_delete_account()
        elif choice == "9":
            run_all_tests()
        else:
            print("❌ Pilihan tidak valid!")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == "--interactive":
        interactive_test()
    else:
        run_all_tests()
