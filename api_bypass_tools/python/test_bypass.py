#!/usr/bin/env python3
"""
Test script untuk API bypass
Gunakan untuk testing berbagai skenario rate limit
"""

import json
import time
from api_bypass import APIBypass

def test_basic_functionality():
    """Test basic functionality"""
    print("=== Testing Basic Functionality ===")
    
    bypass = APIBypass()
    
    # Test dengan httpbin.org (free testing API)
    test_urls = [
        "https://httpbin.org/get",
        "https://httpbin.org/ip", 
        "https://httpbin.org/user-agent",
        "https://httpbin.org/headers"
    ]
    
    for url in test_urls:
        print(f"\nTesting: {url}")
        result = bypass.make_request(url)
        if result:
            print("✅ Success!")
            # Print relevant info
            if 'origin' in result:
                print(f"   IP: {result['origin']}")
            if 'user-agent' in result:
                print(f"   UA: {result['user-agent']}")
        else:
            print("❌ Failed!")

def test_rate_limit_simulation():
    """Simulate rate limit scenario"""
    print("\n=== Testing Rate Limit Simulation ===")
    
    bypass = APIBypass()
    
    # URL yang simulate rate limit (httpbin.org/status/429)
    rate_limit_url = "https://httpbin.org/status/429"
    normal_url = "https://httpbin.org/get"
    
    print("Testing normal request...")
    result1 = bypass.make_request(normal_url)
    print("✅ Normal request OK" if result1 else "❌ Normal request failed")
    
    print("\nTesting rate limited request...")
    result2 = bypass.make_request(rate_limit_url)
    print("✅ Rate limit handled" if not result2 else "❌ Should have failed")

def test_different_methods():
    """Test different HTTP methods"""
    print("\n=== Testing Different HTTP Methods ===")
    
    bypass = APIBypass()
    
    # GET
    print("Testing GET...")
    get_result = bypass.make_request("https://httpbin.org/get")
    print("✅ GET OK" if get_result else "❌ GET failed")
    
    # POST
    print("Testing POST...")
    post_data = {"test": "data", "timestamp": int(time.time())}
    post_result = bypass.make_request(
        "https://httpbin.org/post", 
        "POST", 
        post_data
    )
    print("✅ POST OK" if post_result else "❌ POST failed")
    
    # PUT
    print("Testing PUT...")
    put_data = {"update": "data"}
    put_result = bypass.make_request(
        "https://httpbin.org/put",
        "PUT", 
        put_data
    )
    print("✅ PUT OK" if put_result else "❌ PUT failed")

def test_batch_processing():
    """Test batch processing"""
    print("\n=== Testing Batch Processing ===")
    
    bypass = APIBypass()
    
    urls = [
        "https://httpbin.org/get",
        "https://httpbin.org/ip",
        "https://httpbin.org/user-agent",
        "https://httpbin.org/headers",
        "https://httpbin.org/uuid"
    ]
    
    print(f"Processing {len(urls)} URLs in batch...")
    start_time = time.time()
    
    results = bypass.batch_requests(urls, max_workers=3)
    
    end_time = time.time()
    successful = len([r for r in results if r is not None])
    
    print(f"✅ Batch completed in {end_time - start_time:.2f}s")
    print(f"   Success: {successful}/{len(urls)} requests")

def test_with_custom_api():
    """Test dengan API yang memerlukan authentication"""
    print("\n=== Testing Custom API ===")
    
    # Contoh untuk testing dengan API nyata
    # Ganti dengan API endpoint yang Anda gunakan
    
    bypass = APIBypass()
    
    # Update API keys (contoh)
    bypass.api_keys = [
        "your_real_api_key_1",
        "your_real_api_key_2"
    ]
    
    # Contoh URL API
    api_url = "https://api.example.com/v1/data"
    
    print(f"Testing real API: {api_url}")
    print("Note: Update api_keys dan api_url untuk testing nyata")
    
    # Uncomment untuk test nyata
    # result = bypass.make_request(api_url)
    # print("✅ Real API OK" if result else "❌ Real API failed")

def stress_test():
    """Stress test untuk check performa"""
    print("\n=== Stress Test ===")
    
    bypass = APIBypass()
    
    # Test dengan banyak request
    num_requests = 10
    urls = ["https://httpbin.org/uuid"] * num_requests
    
    print(f"Stress testing dengan {num_requests} requests...")
    start_time = time.time()
    
    results = bypass.batch_requests(urls, max_workers=5)
    
    end_time = time.time()
    successful = len([r for r in results if r is not None])
    
    print(f"✅ Stress test completed in {end_time - start_time:.2f}s")
    print(f"   Success rate: {successful/num_requests*100:.1f}%")
    print(f"   Avg time per request: {(end_time - start_time)/num_requests:.2f}s")

def main():
    """Main test function"""
    print("🚀 API Bypass Testing Suite")
    print("=" * 50)
    
    try:
        test_basic_functionality()
        test_rate_limit_simulation() 
        test_different_methods()
        test_batch_processing()
        test_with_custom_api()
        stress_test()
        
        print("\n" + "=" * 50)
        print("✅ All tests completed!")
        
    except KeyboardInterrupt:
        print("\n❌ Tests interrupted by user")
    except Exception as e:
        print(f"\n❌ Test failed with error: {e}")

if __name__ == "__main__":
    main()
