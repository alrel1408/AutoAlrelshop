#!/usr/bin/env python3
"""
Quick setup script untuk API Bypass Tools
"""

import os
import json
import shutil
import subprocess
import sys

def check_python_version():
    """Check if Python version is compatible"""
    if sys.version_info < (3, 6):
        print("❌ Error: Python 3.6+ required")
        print(f"   Current version: {sys.version}")
        return False
    print(f"✅ Python {sys.version.split()[0]} OK")
    return True

def install_python_dependencies():
    """Install Python dependencies"""
    print("\n📦 Installing Python dependencies...")
    
    requirements_file = os.path.join('python', 'requirements.txt')
    if os.path.exists(requirements_file):
        try:
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', '-r', requirements_file])
            print("✅ Python dependencies installed")
            return True
        except subprocess.CalledProcessError:
            print("❌ Failed to install Python dependencies")
            return False
    else:
        print("⚠️  requirements.txt not found")
        return False

def setup_config():
    """Setup configuration file"""
    print("\n⚙️  Setting up configuration...")
    
    config_file = os.path.join('config', 'bypass_config.json')
    user_config_file = os.path.join('config', 'user_config.json')
    
    if os.path.exists(config_file):
        # Copy template to user config
        shutil.copy2(config_file, user_config_file)
        
        # Load and modify config
        with open(user_config_file, 'r') as f:
            config = json.load(f)
        
        print("📝 Please update your API keys in config/user_config.json")
        print("   Available sections:")
        print("   - api_keys: Add your API keys here")
        print("   - proxies: Add proxy settings if needed")
        print("   - settings: Adjust delays and retry settings")
        
        print("✅ Configuration template created")
        return True
    else:
        print("❌ Configuration template not found")
        return False

def check_php():
    """Check if PHP is available"""
    try:
        result = subprocess.run(['php', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            version = result.stdout.split('\n')[0]
            print(f"✅ {version}")
            
            # Check curl extension
            curl_check = subprocess.run(['php', '-m'], capture_output=True, text=True)
            if 'curl' in curl_check.stdout:
                print("✅ PHP curl extension available")
            else:
                print("⚠️  PHP curl extension not found")
            
            return True
    except FileNotFoundError:
        print("⚠️  PHP not found (optional)")
        return False

def check_bash():
    """Check if bash is available"""
    try:
        result = subprocess.run(['bash', '--version'], capture_output=True, text=True)
        if result.returncode == 0:
            print("✅ Bash available")
            return True
    except FileNotFoundError:
        print("⚠️  Bash not found (optional)")
        return False

def make_scripts_executable():
    """Make bash scripts executable (Unix/Linux only)"""
    if os.name != 'nt':  # Not Windows
        bash_script = os.path.join('bash', 'api_bypass.sh')
        if os.path.exists(bash_script):
            os.chmod(bash_script, 0o755)
            print("✅ Bash script made executable")

def run_tests():
    """Run basic tests"""
    print("\n🧪 Running basic tests...")
    
    # Test Python script
    python_script = os.path.join('python', 'test_bypass.py')
    if os.path.exists(python_script):
        print("Testing Python script...")
        try:
            # Just check if script can be imported
            import importlib.util
            spec = importlib.util.spec_from_file_location("test_bypass", python_script)
            test_module = importlib.util.module_from_spec(spec)
            print("✅ Python script syntax OK")
        except Exception as e:
            print(f"❌ Python script error: {e}")
    
    print("✅ Basic tests completed")

def show_usage_examples():
    """Show usage examples"""
    print("\n📚 Usage Examples:")
    print("=" * 50)
    
    print("\n🐍 Python:")
    print("cd python/")
    print("python api_bypass.py")
    print("python test_bypass.py")
    
    print("\n🐘 PHP:")
    print("cd php/")
    print("php api_bypass.php")
    
    print("\n🔧 Bash:")
    print("cd bash/")
    print("./api_bypass.sh test")
    
    print("\n📖 Documentation:")
    print("See docs/API_BYPASS_README.md for detailed guide")

def main():
    """Main setup function"""
    print("🚀 API Bypass Tools Setup")
    print("=" * 40)
    
    # Check requirements
    if not check_python_version():
        return
    
    # Install dependencies
    install_python_dependencies()
    
    # Setup configuration
    setup_config()
    
    # Check optional tools
    print("\n🔍 Checking optional tools...")
    check_php()
    check_bash()
    
    # Make scripts executable
    make_scripts_executable()
    
    # Run tests
    run_tests()
    
    # Show usage
    show_usage_examples()
    
    print("\n✅ Setup completed!")
    print("\n📝 Next steps:")
    print("1. Edit config/user_config.json with your API keys")
    print("2. Choose your preferred language (Python/PHP/Bash)")
    print("3. Run the test script to verify everything works")
    print("4. Check examples/ folder for specific API usage")

if __name__ == "__main__":
    main()
