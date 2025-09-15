#!/bin/bash

# GTM Automation Setup Script
# Automatically installs Docker, Node.js, and project dependencies

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    
    log_info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Docker Desktop directly on Windows
install_docker_direct_windows() {
    log_info "Downloading Docker Desktop installer..."
    
    local docker_url="https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    local docker_installer="/tmp/DockerDesktopInstaller.exe"
    
    # Download Docker Desktop installer
    if command_exists curl; then
        curl -L "$docker_url" -o "$docker_installer"
    elif command_exists wget; then
        wget "$docker_url" -O "$docker_installer"
    else
        log_error "Neither curl nor wget found. Cannot download Docker installer."
        return 1
    fi
    
    if [ -f "$docker_installer" ]; then
        log_success "Docker installer downloaded"
        
        # Install Docker Desktop
        log_info "Installing Docker Desktop (this may take several minutes)..."
        "$docker_installer" install --quiet --accept-license
        
        if [ $? -eq 0 ]; then
            log_success "Docker Desktop installed successfully"
            rm -f "$docker_installer"
            
            # Add Docker to PATH
            export PATH="$PATH:/c/Program Files/Docker/Docker/resources/bin"
            return 0
        else
            log_error "Docker Desktop installation failed"
            rm -f "$docker_installer"
            return 1
        fi
    else
        log_error "Failed to download Docker installer"
        return 1
    fi
}

# Install Docker
install_docker() {
    log_info "Checking Docker installation..."
    
    if command_exists docker; then
        DOCKER_VERSION=$(docker --version)
        log_success "Docker is already installed: $DOCKER_VERSION"
        
        # Check if Docker is running
        if ! docker info >/dev/null 2>&1; then
            log_warning "Docker is installed but not running. Please start Docker Desktop manually."
            if [[ "$OS" == "windows" ]]; then
                log_info "Start Docker Desktop from Start Menu or Desktop shortcut"
            fi
            read -p "Press Enter once Docker Desktop is running..."
        else
            log_success "Docker is running"
        fi
        return
    fi
    
    log_info "Docker not found. Installing Docker..."
    
    case $OS in
        "windows")
            log_info "Installing Docker Desktop for Windows automatically..."
            
            # Try chocolatey first
            if command_exists choco; then
                log_info "Installing Docker Desktop via Chocolatey..."
                choco install docker-desktop -y --limit-output
                
                # Refresh PATH
                export PATH="$PATH:/c/Program Files/Docker/Docker/resources/bin"
                
                if command_exists docker; then
                    log_success "Docker Desktop installed via Chocolatey"
                else
                    log_warning "Chocolatey installation didn't work, trying direct download..."
                    install_docker_direct_windows
                fi
            else
                install_docker_direct_windows
            fi
            
            # Start Docker Desktop
            log_info "Starting Docker Desktop..."
            "/c/Program Files/Docker/Docker/Docker Desktop.exe" &
            
            # Wait for Docker to be ready
            log_info "Waiting for Docker Desktop to initialize (this may take a few minutes)..."
            timeout=180
            elapsed=0
            while [ $elapsed -lt $timeout ]; do
                sleep 10
                elapsed=$((elapsed + 10))
                
                if docker info >/dev/null 2>&1; then
                    log_success "Docker Desktop is ready!"
                    break
                fi
                
                log_info "Docker starting... ($elapsed/$timeout seconds)"
            done
            
            if ! docker info >/dev/null 2>&1; then
                log_warning "Docker Desktop is taking longer than expected to start."
                log_info "Please wait for Docker Desktop to fully load in the system tray."
                read -p "Press Enter once Docker Desktop is running..."
            fi
            ;;
            
        "linux")
            log_info "Installing Docker on Linux..."
            
            # Update package index
            sudo apt-get update
            
            # Install prerequisites
            sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                gnupg \
                lsb-release
            
            # Add Docker GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            
            # Add Docker repository
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Install Docker
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            
            # Add user to docker group
            sudo usermod -aG docker $USER
            
            # Start Docker service
            sudo systemctl start docker
            sudo systemctl enable docker
            
            log_success "Docker installed successfully"
            log_warning "Please log out and log back in for group changes to take effect"
            ;;
            
        "macos")
            log_info "For macOS, please install Docker Desktop manually:"
            echo "1. Go to https://www.docker.com/products/docker-desktop/"
            echo "2. Download Docker Desktop for Mac"
            echo "3. Install the .dmg file"
            echo "4. Start Docker Desktop"
            read -p "Press Enter after you've installed and started Docker Desktop..."
            ;;
            
        *)
            log_error "Unsupported operating system for automatic Docker installation"
            echo "Please install Docker manually from https://www.docker.com/products/docker-desktop/"
            exit 1
            ;;
    esac
}

# Install Docker Compose (if not included with Docker Desktop)
install_docker_compose() {
    log_info "Checking Docker Compose installation..."
    
    if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
        if command_exists docker-compose; then
            COMPOSE_VERSION=$(docker-compose --version)
        else
            COMPOSE_VERSION=$(docker compose version)
        fi
        log_success "Docker Compose is available: $COMPOSE_VERSION"
        return
    fi
    
    log_info "Installing Docker Compose..."
    
    case $OS in
        "linux")
            # Install Docker Compose for Linux
            sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
            log_success "Docker Compose installed"
            ;;
        *)
            log_warning "Docker Compose should be included with Docker Desktop"
            ;;
    esac
}

# Install Node.js
install_nodejs() {
    log_info "Checking Node.js installation..."
    
    if command_exists node; then
        NODE_VERSION=$(node --version)
        # Check if version is 18 or higher
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_MAJOR" -ge 18 ]; then
            log_success "Node.js is already installed: $NODE_VERSION"
            return
        else
            log_warning "Node.js version $NODE_VERSION is too old. Need version 18+. Updating..."
        fi
    else
        log_info "Node.js not found. Installing..."
    fi
    
    case $OS in
        "windows")
            log_info "For Windows, installing Node.js via chocolatey or manual download..."
            
            # Try chocolatey first
            if command_exists choco; then
                log_info "Installing Node.js via Chocolatey..."
                choco install nodejs -y
            else
                log_warning "Chocolatey not found. Please install Node.js manually:"
                echo "1. Go to https://nodejs.org/"
                echo "2. Download the LTS version for Windows"
                echo "3. Run the installer"
                echo "4. Restart your terminal"
                read -p "Press Enter after you've installed Node.js..."
            fi
            ;;
            
        "linux")
            log_info "Installing Node.js on Linux..."
            
            # Install via NodeSource repository
            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install -y nodejs
            
            log_success "Node.js installed"
            ;;
            
        "macos")
            log_info "Installing Node.js on macOS..."
            
            # Try homebrew first
            if command_exists brew; then
                brew install node
            else
                log_warning "Homebrew not found. Please install Node.js manually:"
                echo "1. Go to https://nodejs.org/"
                echo "2. Download the LTS version for macOS"
                echo "3. Run the installer"
                read -p "Press Enter after you've installed Node.js..."
            fi
            ;;
            
        *)
            log_error "Unsupported operating system for automatic Node.js installation"
            echo "Please install Node.js manually from https://nodejs.org/"
            exit 1
            ;;
    esac
    
    # Verify installation
    if command_exists node; then
        NODE_VERSION=$(node --version)
        NPM_VERSION=$(npm --version)
        log_success "Node.js installed: $NODE_VERSION"
        log_success "npm installed: $NPM_VERSION"
    else
        log_error "Node.js installation failed. Please install manually and run this script again."
        exit 1
    fi
}

# Install project dependencies
install_project_dependencies() {
    log_info "Installing project dependencies..."
    
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Make sure you're in the project directory."
        exit 1
    fi
    
    # Install npm dependencies
    log_info "Running npm install..."
    npm install
    
    log_success "Project dependencies installed successfully"
}

# Create .env file from template
setup_environment() {
    log_info "Setting up environment configuration..."
    
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            log_success "Created .env file from template"
            log_warning "Please edit .env file and add your API credentials"
        else
            log_error ".env.example not found"
            exit 1
        fi
    else
        log_info ".env file already exists"
    fi
}

# Generate encryption key
generate_encryption_key() {
    log_info "Generating encryption key..."
    
    if command_exists openssl; then
        ENCRYPTION_KEY=$(openssl rand -hex 16)
    elif command_exists node; then
        ENCRYPTION_KEY=$(node -e "console.log(require('crypto').randomBytes(16).toString('hex'))")
    else
        # Fallback: generate random string
        ENCRYPTION_KEY=$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 32 | head -n 1 2>/dev/null || echo "your_32_character_encryption_key_here")
    fi
    
    # Update .env file with generated key
    if [[ "$OS" == "windows" ]]; then
        # Windows sed syntax
        sed -i "s/N8N_ENCRYPTION_KEY=your_32_character_encryption_key_here/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env
    else
        # Linux/macOS sed syntax
        sed -i "s/N8N_ENCRYPTION_KEY=your_32_character_encryption_key_here/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env
    fi
    
    log_success "Encryption key generated and added to .env file"
}

# Validate installation
validate_installation() {
    log_info "Validating installation..."
    
    # Check Docker
    if ! command_exists docker; then
        log_error "Docker validation failed"
        return 1
    fi
    
    # Check Docker is running
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker is not running"
        return 1
    fi
    
    # Check Node.js
    if ! command_exists node; then
        log_error "Node.js validation failed"
        return 1
    fi
    
    # Check project dependencies
    if [ ! -d "node_modules" ]; then
        log_error "Project dependencies not installed"
        return 1
    fi
    
    # Check .env file
    if [ ! -f ".env" ]; then
        log_error ".env file not found"
        return 1
    fi
    
    log_success "All validations passed!"
    return 0
}

# Main installation process
main() {
    log_info "Starting GTM Automation Setup..."
    echo "============================================="
    
    # Detect operating system
    detect_os
    
    # Install Docker
    install_docker
    
    # Install Docker Compose
    install_docker_compose
    
    # Install Node.js
    install_nodejs
    
    # Install project dependencies
    install_project_dependencies
    
    # Setup environment
    setup_environment
    
    # Generate encryption key
    generate_encryption_key
    
    # Validate installation
    if validate_installation; then
        echo ""
        log_success "✅ Setup completed successfully!"
        echo "============================================="
        echo ""
        echo "Next steps:"
        echo "1. Edit .env file and add your API credentials:"
        echo "   - Reddit API credentials"
        echo "   - OpenAI API key"
        echo "   - Google Sheets API credentials"
        echo "   - Slack webhook URL"
        echo ""
        echo "2. Start the system:"
        echo "   npm run start"
        echo ""
        echo "3. Access n8n at http://localhost:5678"
        echo ""
    else
        log_error "Setup validation failed. Please check the errors above."
        exit 1
    fi
}

# Run main function
main "$@"