#!/usr/bin/env python3
"""
API Rate Limit Bypass Script
Supports multiple bypass techniques
"""

import requests
import time
import random
import json
from itertools import cycle
import threading
from urllib.parse import urljoin

class APIBypass:
    def __init__(self):
        # Multiple API keys for rotation
        self.api_keys = [
            "your_api_key_1",
            "your_api_key_2", 
            "your_api_key_3",
            # Tambahkan lebih banyak API keys
        ]
        
        # User agents untuk rotation
        self.user_agents = [
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/121.0"
        ]
        
        # Proxy list untuk IP rotation
        self.proxies_list = [
            {"http": "http://proxy1:port", "https": "https://proxy1:port"},
            {"http": "http://proxy2:port", "https": "https://proxy2:port"},
            # Tambahkan proxy lainnya
        ]
        
        self.api_key_cycle = cycle(self.api_keys)
        self.user_agent_cycle = cycle(self.user_agents)
        self.proxy_cycle = cycle(self.proxies_list)
        
        self.request_count = 0
        self.last_request_time = 0
        self.min_delay = 1  # Minimum delay between requests
        
    def get_headers(self, api_key=None):
        """Generate headers with rotation"""
        headers = {
            "User-Agent": next(self.user_agent_cycle),
            "Accept": "application/json",
            "Accept-Language": "en-US,en;q=0.9",
            "Accept-Encoding": "gzip, deflate, br",
            "DNT": "1",
            "Connection": "keep-alive",
            "Upgrade-Insecure-Requests": "1"
        }
        
        if api_key:
            headers["Authorization"] = f"Bearer {api_key}"
            # atau headers["X-API-Key"] = api_key
            
        return headers
    
    def wait_if_needed(self):
        """Implement intelligent delay"""
        current_time = time.time()
        time_since_last = current_time - self.last_request_time
        
        if time_since_last < self.min_delay:
            sleep_time = self.min_delay - time_since_last
            time.sleep(sleep_time)
            
        self.last_request_time = time.time()
    
    def make_request(self, url, method="GET", data=None, use_api_key=True, max_retries=3):
        """Make API request with bypass techniques"""
        
        for attempt in range(max_retries):
            try:
                self.wait_if_needed()
                
                # Get next API key
                api_key = next(self.api_key_cycle) if use_api_key else None
                headers = self.get_headers(api_key)
                
                # Get next proxy (comment out if no proxies)
                # proxies = next(self.proxy_cycle)
                proxies = None
                
                # Add random delay
                if attempt > 0:
                    delay = random.uniform(1, 3) * attempt
                    time.sleep(delay)
                
                session = requests.Session()
                session.headers.update(headers)
                
                if method.upper() == "GET":
                    response = session.get(url, proxies=proxies, timeout=30)
                elif method.upper() == "POST":
                    response = session.post(url, json=data, proxies=proxies, timeout=30)
                elif method.upper() == "PUT":
                    response = session.put(url, json=data, proxies=proxies, timeout=30)
                
                # Check if rate limited
                if response.status_code == 429:
                    print(f"Rate limited on attempt {attempt + 1}, retrying...")
                    retry_after = response.headers.get('Retry-After', 60)
                    time.sleep(int(retry_after))
                    continue
                
                if response.status_code == 200:
                    self.request_count += 1
                    return response.json()
                else:
                    print(f"Request failed with status {response.status_code}: {response.text}")
                    
            except requests.exceptions.RequestException as e:
                print(f"Request error on attempt {attempt + 1}: {e}")
                if attempt == max_retries - 1:
                    raise
                time.sleep(random.uniform(2, 5))
        
        return None
    
    def batch_requests(self, urls, max_workers=5):
        """Process multiple requests with threading"""
        results = []
        
        def worker(url):
            result = self.make_request(url)
            results.append(result)
        
        threads = []
        for url in urls:
            if len(threads) >= max_workers:
                # Wait for some threads to complete
                for t in threads[:max_workers//2]:
                    t.join()
                threads = [t for t in threads if t.is_alive()]
            
            thread = threading.Thread(target=worker, args=(url,))
            thread.start()
            threads.append(thread)
            
            # Small delay between thread starts
            time.sleep(0.1)
        
        # Wait for all threads to complete
        for thread in threads:
            thread.join()
            
        return results

# Usage examples
if __name__ == "__main__":
    bypass = APIBypass()
    
    # Single request
    result = bypass.make_request("https://api.example.com/data")
    print(json.dumps(result, indent=2))
    
    # Multiple requests
    urls = [
        "https://api.example.com/data1",
        "https://api.example.com/data2",
        "https://api.example.com/data3"
    ]
    results = bypass.batch_requests(urls)
    print(f"Processed {len(results)} requests")
