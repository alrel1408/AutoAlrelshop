<?php
/**
 * API Rate Limit Bypass Script in PHP
 * Supports multiple bypass techniques
 */

class APIBypass {
    private $apiKeys = [
        'your_api_key_1',
        'your_api_key_2', 
        'your_api_key_3',
        // Tambahkan lebih banyak API keys
    ];
    
    private $userAgents = [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0',
    ];
    
    private $proxies = [
        // 'proxy1:port',
        // 'proxy2:port',
        // Tambahkan proxy jika ada
    ];
    
    private $requestCount = 0;
    private $lastRequestTime = 0;
    private $minDelay = 1; // seconds
    
    public function __construct() {
        // Shuffle arrays for randomization
        shuffle($this->apiKeys);
        shuffle($this->userAgents);
        shuffle($this->proxies);
    }
    
    private function getRandomUserAgent() {
        return $this->userAgents[array_rand($this->userAgents)];
    }
    
    private function getRandomApiKey() {
        return $this->apiKeys[array_rand($this->apiKeys)];
    }
    
    private function getRandomProxy() {
        return !empty($this->proxies) ? $this->proxies[array_rand($this->proxies)] : null;
    }
    
    private function waitIfNeeded() {
        $currentTime = time();
        $timeSinceLast = $currentTime - $this->lastRequestTime;
        
        if ($timeSinceLast < $this->minDelay) {
            $sleepTime = $this->minDelay - $timeSinceLast;
            sleep($sleepTime);
        }
        
        $this->lastRequestTime = time();
    }
    
    private function buildHeaders($apiKey = null) {
        $headers = [
            'User-Agent: ' . $this->getRandomUserAgent(),
            'Accept: application/json',
            'Accept-Language: en-US,en;q=0.9',
            'Accept-Encoding: gzip, deflate, br',
            'DNT: 1',
            'Connection: keep-alive',
            'Cache-Control: no-cache',
        ];
        
        if ($apiKey && $apiKey !== 'your_api_key_1') {
            $headers[] = 'Authorization: Bearer ' . $apiKey;
            // atau $headers[] = 'X-API-Key: ' . $apiKey;
        }
        
        return $headers;
    }
    
    public function makeRequest($url, $method = 'GET', $data = null, $useApiKey = true, $maxRetries = 3) {
        for ($attempt = 1; $attempt <= $maxRetries; $attempt++) {
            echo "Attempt $attempt/$maxRetries for: $url\n";
            
            $this->waitIfNeeded();
            
            // Setup cURL
            $ch = curl_init();
            $apiKey = $useApiKey ? $this->getRandomApiKey() : null;
            $headers = $this->buildHeaders($apiKey);
            $proxy = $this->getRandomProxy();
            
            // Basic cURL options
            curl_setopt_array($ch, [
                CURLOPT_URL => $url,
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT => 30,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_HTTPHEADER => $headers,
                CURLOPT_SSL_VERIFYPEER => false,
                CURLOPT_ENCODING => '', // Enable gzip
            ]);
            
            // Set proxy if available
            if ($proxy) {
                curl_setopt($ch, CURLOPT_PROXY, $proxy);
            }
            
            // Set method and data
            switch (strtoupper($method)) {
                case 'POST':
                    curl_setopt($ch, CURLOPT_POST, true);
                    if ($data) {
                        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
                        $headers[] = 'Content-Type: application/json';
                        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
                    }
                    break;
                case 'PUT':
                    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
                    if ($data) {
                        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
                        $headers[] = 'Content-Type: application/json';
                        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
                    }
                    break;
                case 'DELETE':
                    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
                    break;
            }
            
            // Execute request
            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $error = curl_error($ch);
            curl_close($ch);
            
            echo "HTTP Code: $httpCode\n";
            
            if ($error) {
                echo "cURL Error: $error\n";
                if ($attempt < $maxRetries) {
                    sleep(rand(2, 5));
                    continue;
                }
                return false;
            }
            
            // Handle response
            if ($httpCode == 200) {
                $this->requestCount++;
                echo "Success! Request #" . $this->requestCount . "\n";
                return json_decode($response, true);
            } elseif ($httpCode == 429) {
                echo "Rate limited, waiting...\n";
                if ($attempt < $maxRetries) {
                    $waitTime = 30 + rand(0, 60); // 30-90 seconds
                    echo "Waiting $waitTime seconds...\n";
                    sleep($waitTime);
                    continue;
                }
            } else {
                echo "Error $httpCode: $response\n";
                if ($attempt < $maxRetries) {
                    sleep(rand(1, 3) * $attempt);
                    continue;
                }
            }
        }
        
        echo "All attempts failed for: $url\n";
        return false;
    }
    
    public function batchRequests($urls, $delayBetween = 2) {
        $results = [];
        $count = 0;
        
        foreach ($urls as $url) {
            $count++;
            echo "\nProcessing URL $count/" . count($urls) . ": $url\n";
            
            $result = $this->makeRequest($url);
            $results[] = [
                'url' => $url,
                'success' => $result !== false,
                'data' => $result
            ];
            
            if ($count < count($urls)) {
                echo "Waiting $delayBetween seconds before next request...\n";
                sleep($delayBetween);
            }
        }
        
        return $results;
    }
    
    public function getStats() {
        return [
            'total_requests' => $this->requestCount,
            'available_keys' => count($this->apiKeys),
            'available_proxies' => count($this->proxies)
        ];
    }
}

// Usage example
if (php_sapi_name() === 'cli') {
    echo "API Bypass Script\n";
    echo "==================\n\n";
    
    $bypass = new APIBypass();
    
    // Example 1: Single request
    echo "Testing single request...\n";
    $result = $bypass->makeRequest('https://httpbin.org/get');
    if ($result) {
        echo "Response: " . json_encode($result, JSON_PRETTY_PRINT) . "\n\n";
    }
    
    // Example 2: Batch requests
    $urls = [
        'https://httpbin.org/get',
        'https://httpbin.org/ip',
        'https://httpbin.org/user-agent'
    ];
    
    echo "Testing batch requests...\n";
    $results = $bypass->batchRequests($urls, 1);
    
    echo "\nBatch Results:\n";
    foreach ($results as $result) {
        echo "URL: " . $result['url'] . " - " . ($result['success'] ? 'SUCCESS' : 'FAILED') . "\n";
    }
    
    // Show stats
    echo "\nStats: " . json_encode($bypass->getStats(), JSON_PRETTY_PRINT) . "\n";
}
?>
