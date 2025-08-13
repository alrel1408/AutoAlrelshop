#!/bin/bash

# API Bypass Script menggunakan curl
# Mendukung berbagai teknik bypass rate limit

# Array API keys untuk rotasi
API_KEYS=(
    "key1_here"
    "key2_here" 
    "key3_here"
    # Tambahkan key lainnya
)

# Array User Agents
USER_AGENTS=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101"
)

# Array Proxy servers (opsional)
PROXIES=(
    "--proxy http://proxy1:port"
    "--proxy http://proxy2:port"
    # Tambahkan proxy lainnya
)

# Fungsi untuk mendapatkan random user agent
get_random_ua() {
    echo "${USER_AGENTS[$RANDOM % ${#USER_AGENTS[@]}]}"
}

# Fungsi untuk mendapatkan random API key
get_random_key() {
    echo "${API_KEYS[$RANDOM % ${#API_KEYS[@]}]}"
}

# Fungsi untuk mendapatkan random proxy
get_random_proxy() {
    if [ ${#PROXIES[@]} -gt 0 ]; then
        echo "${PROXIES[$RANDOM % ${#PROXIES[@]}]}"
    else
        echo ""
    fi
}

# Fungsi untuk delay random
random_delay() {
    sleep $(echo "scale=2; $RANDOM/32767*3+1" | bc -l)
}

# Fungsi untuk bypass API call
api_bypass_call() {
    local url="$1"
    local method="${2:-GET}"
    local data="$3"
    local max_retries="${4:-3}"
    
    for ((i=1; i<=max_retries; i++)); do
        echo "Attempt $i/$max_retries..."
        
        # Get random values
        local ua=$(get_random_ua)
        local api_key=$(get_random_key)
        local proxy=$(get_random_proxy)
        
        # Build curl command
        local curl_cmd="curl -s"
        curl_cmd+=" -H 'User-Agent: $ua'"
        curl_cmd+=" -H 'Accept: application/json'"
        curl_cmd+=" -H 'Accept-Language: en-US,en;q=0.9'"
        
        # Add API key if available
        if [ ! -z "$api_key" ] && [ "$api_key" != "key1_here" ]; then
            curl_cmd+=" -H 'Authorization: Bearer $api_key'"
            # atau curl_cmd+=" -H 'X-API-Key: $api_key'"
        fi
        
        # Add proxy if available
        if [ ! -z "$proxy" ]; then
            curl_cmd+=" $proxy"
        fi
        
        # Add method and data
        if [ "$method" = "POST" ] && [ ! -z "$data" ]; then
            curl_cmd+=" -X POST -H 'Content-Type: application/json' -d '$data'"
        elif [ "$method" = "PUT" ] && [ ! -z "$data" ]; then
            curl_cmd+=" -X PUT -H 'Content-Type: application/json' -d '$data'"
        fi
        
        curl_cmd+=" '$url'"
        
        # Execute request
        echo "Executing: $curl_cmd"
        response=$(eval $curl_cmd)
        http_code=$(curl -s -o /dev/null -w "%{http_code}" \
            -H "User-Agent: $ua" \
            -H "Accept: application/json" \
            $([ ! -z "$api_key" ] && [ "$api_key" != "key1_here" ] && echo "-H 'Authorization: Bearer $api_key'") \
            $([ ! -z "$proxy" ] && echo "$proxy") \
            $([ "$method" = "POST" ] && [ ! -z "$data" ] && echo "-X POST -H 'Content-Type: application/json' -d '$data'") \
            "$url")
        
        echo "HTTP Code: $http_code"
        
        # Check response
        if [ "$http_code" = "200" ]; then
            echo "Success!"
            echo "$response"
            return 0
        elif [ "$http_code" = "429" ]; then
            echo "Rate limited, waiting..."
            if [ $i -lt $max_retries ]; then
                sleep $((30 + $RANDOM % 60))  # Wait 30-90 seconds
            fi
        else
            echo "Error $http_code: $response"
            if [ $i -lt $max_retries ]; then
                random_delay
            fi
        fi
    done
    
    echo "All attempts failed"
    return 1
}

# Fungsi untuk multiple requests dengan delay
batch_requests() {
    local urls_file="$1"
    local delay_between="${2:-2}"
    
    if [ ! -f "$urls_file" ]; then
        echo "URLs file not found: $urls_file"
        return 1
    fi
    
    local count=0
    while IFS= read -r url; do
        if [ ! -z "$url" ] && [[ ! "$url" =~ ^# ]]; then
            echo "Processing URL $((++count)): $url"
            api_bypass_call "$url"
            
            if [ $count -gt 1 ]; then
                echo "Waiting $delay_between seconds..."
                sleep $delay_between
            fi
        fi
    done < "$urls_file"
}

# Fungsi untuk membuat session dengan cookies
session_bypass() {
    local base_url="$1"
    local cookie_jar="/tmp/api_cookies_$$"
    
    # Login atau get session
    echo "Creating session..."
    curl -s -c "$cookie_jar" \
        -H "User-Agent: $(get_random_ua)" \
        "$base_url/login" > /dev/null
    
    # Use session for requests
    api_bypass_call_with_session() {
        local url="$1"
        curl -s -b "$cookie_jar" \
            -H "User-Agent: $(get_random_ua)" \
            -H "Accept: application/json" \
            "$url"
    }
    
    # Export function for use
    export -f api_bypass_call_with_session
    
    # Cleanup on exit
    trap "rm -f $cookie_jar" EXIT
}

# Usage examples
case "${1:-help}" in
    "single")
        api_bypass_call "$2" "$3" "$4"
        ;;
    "batch")
        batch_requests "$2" "$3"
        ;;
    "session")
        session_bypass "$2"
        ;;
    "test")
        echo "Testing API bypass..."
        api_bypass_call "https://httpbin.org/get" "GET"
        ;;
    *)
        echo "Usage: $0 {single|batch|session|test}"
        echo ""
        echo "Examples:"
        echo "  $0 single 'https://api.example.com/data' GET"
        echo "  $0 batch urls.txt 3"
        echo "  $0 session 'https://api.example.com'"
        echo "  $0 test"
        ;;
esac
