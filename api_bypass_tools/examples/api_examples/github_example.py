#!/usr/bin/env python3
"""
Contoh penggunaan bypass untuk GitHub API
"""

import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..', 'python'))

from api_bypass import APIBypass

class GitHubBypass(APIBypass):
    def __init__(self):
        super().__init__()
        # GitHub API settings
        self.base_url = "https://api.github.com"
        
        # GitHub tokens (ganti dengan tokens Anda)
        self.api_keys = [
            "ghp_your_github_token_1",
            "ghp_your_github_token_2",
            "ghp_your_github_token_3"
        ]
    
    def get_user_info(self, username=None):
        """Get user information"""
        if username:
            url = f"{self.base_url}/users/{username}"
        else:
            url = f"{self.base_url}/user"  # authenticated user
        
        return self.make_request(url)
    
    def get_repositories(self, username, page=1, per_page=30):
        """Get user repositories"""
        url = f"{self.base_url}/users/{username}/repos"
        url += f"?page={page}&per_page={per_page}"
        
        return self.make_request(url)
    
    def search_repositories(self, query, sort="stars", order="desc"):
        """Search repositories"""
        url = f"{self.base_url}/search/repositories"
        url += f"?q={query}&sort={sort}&order={order}"
        
        return self.make_request(url)
    
    def get_rate_limit(self):
        """Check current rate limit status"""
        url = f"{self.base_url}/rate_limit"
        return self.make_request(url)
    
    def get_repo_info(self, owner, repo):
        """Get repository information"""
        url = f"{self.base_url}/repos/{owner}/{repo}"
        return self.make_request(url)
    
    def get_repo_commits(self, owner, repo, page=1):
        """Get repository commits"""
        url = f"{self.base_url}/repos/{owner}/{repo}/commits"
        url += f"?page={page}&per_page=30"
        
        return self.make_request(url)

def main():
    """Contoh penggunaan"""
    github = GitHubBypass()
    
    # Test 1: Check rate limit
    print("Checking rate limit...")
    rate_limit = github.get_rate_limit()
    if rate_limit:
        core_limit = rate_limit.get('rate', {})
        print(f"Rate limit: {core_limit.get('remaining')}/{core_limit.get('limit')}")
        print(f"Reset time: {core_limit.get('reset')}")
    
    # Test 2: Get user info
    print("\nGetting user info...")
    user_info = github.get_user_info("octocat")  # GitHub mascot
    if user_info:
        print(f"User: {user_info.get('login')}")
        print(f"Name: {user_info.get('name')}")
        print(f"Followers: {user_info.get('followers')}")
        print(f"Public repos: {user_info.get('public_repos')}")
    
    # Test 3: Search repositories
    print("\nSearching popular Python repositories...")
    search_results = github.search_repositories("language:python", sort="stars")
    if search_results:
        repos = search_results.get('items', [])[:5]  # Top 5
        print(f"Found {search_results.get('total_count')} repositories")
        
        for i, repo in enumerate(repos, 1):
            print(f"{i}. {repo.get('full_name')} - {repo.get('stargazers_count')} stars")
    
    # Test 4: Get specific repository info
    print("\nGetting repository info...")
    repo_info = github.get_repo_info("microsoft", "vscode")
    if repo_info:
        print(f"Repository: {repo_info.get('full_name')}")
        print(f"Description: {repo_info.get('description')}")
        print(f"Stars: {repo_info.get('stargazers_count')}")
        print(f"Forks: {repo_info.get('forks_count')}")
        print(f"Language: {repo_info.get('language')}")
    
    # Test 5: Batch requests for multiple repositories
    print("\nTesting batch requests for multiple repos...")
    popular_repos = [
        ("facebook", "react"),
        ("microsoft", "typescript"),
        ("google", "tensorflow"),
        ("torvalds", "linux")
    ]
    
    urls = [f"https://api.github.com/repos/{owner}/{repo}" for owner, repo in popular_repos]
    results = github.batch_requests(urls, max_workers=3)
    
    print(f"Successfully fetched {len([r for r in results if r])} repositories")
    
    for result, (owner, repo) in zip(results, popular_repos):
        if result:
            stars = result.get('stargazers_count', 0)
            print(f"  {owner}/{repo}: {stars:,} stars")

if __name__ == "__main__":
    main()
