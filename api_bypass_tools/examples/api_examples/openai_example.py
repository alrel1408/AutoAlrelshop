#!/usr/bin/env python3
"""
Contoh penggunaan bypass untuk OpenAI API
"""

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))

from api_bypass import APIBypass

class OpenAIBypass(APIBypass):
    def __init__(self):
        super().__init__()
        # Khusus untuk OpenAI API
        self.base_url = "https://api.openai.com/v1"
        
        # OpenAI API keys (ganti dengan keys Anda)
        self.api_keys = [
            "sk-your_openai_key_1",
            "sk-your_openai_key_2", 
            "sk-your_openai_key_3"
        ]
    
    def chat_completion(self, messages, model="gpt-3.5-turbo", max_tokens=150):
        """Request chat completion dengan bypass"""
        url = f"{self.base_url}/chat/completions"
        
        data = {
            "model": model,
            "messages": messages,
            "max_tokens": max_tokens,
            "temperature": 0.7
        }
        
        return self.make_request(url, "POST", data)
    
    def text_completion(self, prompt, model="text-davinci-003", max_tokens=100):
        """Request text completion dengan bypass"""
        url = f"{self.base_url}/completions"
        
        data = {
            "model": model,
            "prompt": prompt,
            "max_tokens": max_tokens,
            "temperature": 0.7
        }
        
        return self.make_request(url, "POST", data)
    
    def list_models(self):
        """List available models"""
        url = f"{self.base_url}/models"
        return self.make_request(url, "GET")

def main():
    """Contoh penggunaan"""
    openai = OpenAIBypass()
    
    # Test 1: List models
    print("Testing list models...")
    models = openai.list_models()
    if models:
        print(f"Found {len(models.get('data', []))} models")
    
    # Test 2: Chat completion
    print("\nTesting chat completion...")
    messages = [
        {"role": "user", "content": "Hello, how are you?"}
    ]
    
    response = openai.chat_completion(messages)
    if response:
        print("Chat response:", response.get('choices', [{}])[0].get('message', {}).get('content'))
    
    # Test 3: Multiple requests (batch)
    print("\nTesting multiple chat requests...")
    prompts = [
        "What is AI?",
        "Explain machine learning",
        "What is deep learning?"
    ]
    
    for i, prompt in enumerate(prompts, 1):
        print(f"\nRequest {i}: {prompt}")
        messages = [{"role": "user", "content": prompt}]
        response = openai.chat_completion(messages, max_tokens=50)
        
        if response:
            content = response.get('choices', [{}])[0].get('message', {}).get('content', 'No response')
            print(f"Response: {content[:100]}...")

if __name__ == "__main__":
    main()
