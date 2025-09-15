# GTM Automation Setup Script for Windows PowerShell
# Automatically installs Docker, Node.js, and project dependencies

# Set execution policy for this session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Colors for output
function Write-Info { param($Message) Write-Host "[INFO] $Message" -ForegroundColor Blue }
function Write-Success { param($Message) Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
function Write-Warning { param($Message) Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }

function Test-Command {
    param($Command)
    $null = Get-Command $Command -ErrorAction SilentlyContinue
    return $?
}

Write-Info "Starting GTM Automation Setup for Windows..."
Write-Host "=============================================" -ForegroundColor Cyan

# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "Some installations may require administrator privileges."
    Write-Info "Consider running PowerShell as Administrator if installations fail."
}

# Check if Chocolatey is installed
Write-Info "Checking Chocolatey package manager..."
if (-not (Test-Command "choco")) {
    Write-Info "Installing Chocolatey package manager..."
    try {
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        Write-Success "Chocolatey installed successfully"
    }
    catch {
        Write-Warning "Chocolatey installation failed. Will attempt manual installations."
    }
}
else {
    Write-Success "Chocolatey is already installed"
}

# Function to download and install Docker Desktop automatically
function Install-DockerDesktop {
    Write-Info "Downloading Docker Desktop for Windows..."
    
    $dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    $dockerInstaller = "$env:TEMP\DockerDesktopInstaller.exe"
    
    try {
        # Download Docker Desktop installer
        Write-Info "Downloading Docker Desktop installer..."
        Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller -UseBasicParsing
        Write-Success "Docker Desktop installer downloaded"
        
        # Install Docker Desktop silently
        Write-Info "Installing Docker Desktop (this may take several minutes)..."
        $installProcess = Start-Process -FilePath $dockerInstaller -ArgumentList "install", "--quiet", "--accept-license" -Wait -PassThru
        
        if ($installProcess.ExitCode -eq 0) {
            Write-Success "Docker Desktop installed successfully"
            
            # Clean up installer
            Remove-Item $dockerInstaller -Force -ErrorAction SilentlyContinue
            
            # Add Docker to PATH for current session
            $dockerPath = "${env:ProgramFiles}\Docker\Docker\resources\bin"
            if (Test-Path $dockerPath) {
                $env:Path += ";$dockerPath"
            }
            
            Write-Info "Docker Desktop has been installed. It will start automatically."
            Write-Info "Waiting for Docker Desktop to initialize..."
            
            # Wait for Docker Desktop to start (up to 3 minutes)
            $timeout = 180 # 3 minutes
            $elapsed = 0
            $interval = 10
            
            while ($elapsed -lt $timeout) {
                Start-Sleep -Seconds $interval
                $elapsed += $interval
                
                try {
                    docker version | Out-Null
                    Write-Success "Docker Desktop is ready!"
                    return $true
                }
                catch {
                    Write-Info "Waiting for Docker Desktop to start... ($elapsed/$timeout seconds)"
                }
            }
            
            Write-Warning "Docker Desktop is taking longer than expected to start."
            Write-Info "You may need to start Docker Desktop manually from the Start Menu."
            return $false
        }
        else {
            Write-Error "Docker Desktop installation failed with exit code: $($installProcess.ExitCode)"
            return $false
        }
    }
    catch {
        Write-Error "Failed to download or install Docker Desktop: $($_.Exception.Message)"
        
        # Clean up partial download
        if (Test-Path $dockerInstaller) {
            Remove-Item $dockerInstaller -Force -ErrorAction SilentlyContinue
        }
        return $false
    }
}

# Check and install Docker
Write-Info "Checking Docker installation..."
if (-not (Test-Command "docker")) {
    Write-Info "Docker not found. Installing Docker Desktop automatically..."
    
    # Try Chocolatey first (faster if available)
    if (Test-Command "choco") {
        Write-Info "Attempting installation via Chocolatey..."
        try {
            choco install docker-desktop -y --limit-output
            
            # Refresh PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            
            if (Test-Command "docker") {
                Write-Success "Docker Desktop installed successfully via Chocolatey"
                
                # Start Docker Desktop
                Write-Info "Starting Docker Desktop..."
                Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -ErrorAction SilentlyContinue
                
                # Wait for Docker to be ready
                Write-Info "Waiting for Docker to initialize..."
                $timeout = 120
                $elapsed = 0
                while ($elapsed -lt $timeout) {
                    Start-Sleep -Seconds 5
                    $elapsed += 5
                    try {
                        docker info | Out-Null
                        Write-Success "Docker is ready!"
                        break
                    }
                    catch {
                        Write-Info "Docker starting... ($elapsed/$timeout seconds)"
                    }
                }
            }
            else {
                throw "Docker command not available after Chocolatey installation"
            }
        }
        catch {
            Write-Warning "Chocolatey installation failed: $($_.Exception.Message)"
            Write-Info "Falling back to direct download method..."
            
            if (-not (Install-DockerDesktop)) {
                Write-Error "Failed to install Docker Desktop automatically"
                Write-Info "Please install Docker Desktop manually from: https://www.docker.com/products/docker-desktop/"
                exit 1
            }
        }
    }
    else {
        # Direct download and install
        if (-not (Install-DockerDesktop)) {
            Write-Error "Failed to install Docker Desktop automatically"
            Write-Info "Please install Docker Desktop manually from: https://www.docker.com/products/docker-desktop/"
            exit 1
        }
    }
}
else {
    $dockerVersion = docker --version
    Write-Success "Docker is already installed: $dockerVersion"
}

# Check if Docker is running
Write-Info "Checking if Docker is running..."
$dockerRunning = $false
$attempts = 0
do {
    try {
        docker info | Out-Null
        $dockerRunning = $true
        Write-Success "Docker is running"
    }
    catch {
        $attempts++
        if ($attempts -lt 3) {
            Write-Warning "Docker is not running. Please start Docker Desktop."
            Write-Info "Waiting for Docker Desktop to start... (Attempt $attempts/3)"
            Start-Sleep -Seconds 10
        }
        else {
            Write-Warning "Docker is not running after multiple attempts."
            Read-Host "Please start Docker Desktop manually and press Enter"
            $attempts = 0
        }
    }
} while (-not $dockerRunning -and $attempts -lt 5)

if (-not $dockerRunning) {
    Write-Error "Cannot proceed without Docker running. Please start Docker Desktop."
    exit 1
}

# Check and install Node.js
Write-Info "Checking Node.js installation..."
if (-not (Test-Command "node")) {
    Write-Info "Node.js not found. Installing Node.js..."
    
    if (Test-Command "choco") {
        try {
            choco install nodejs -y
            # Refresh environment variables
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
            Write-Success "Node.js installed via Chocolatey"
        }
        catch {
            Write-Warning "Chocolatey installation failed. Please install Node.js manually:"
            Write-Host "1. Go to https://nodejs.org/" -ForegroundColor Yellow
            Write-Host "2. Download the LTS version for Windows" -ForegroundColor Yellow
            Write-Host "3. Run the installer" -ForegroundColor Yellow
            Write-Host "4. Restart PowerShell" -ForegroundColor Yellow
            Read-Host "Press Enter after installation"
        }
    }
    else {
        Write-Warning "Please install Node.js manually:"
        Write-Host "1. Go to https://nodejs.org/" -ForegroundColor Yellow
        Write-Host "2. Download the LTS version for Windows" -ForegroundColor Yellow
        Write-Host "3. Run the installer" -ForegroundColor Yellow
        Write-Host "4. Restart PowerShell" -ForegroundColor Yellow
        Read-Host "Press Enter after installation"
    }
}
else {
    $nodeVersion = node --version
    # Check if version is 18 or higher
    $majorVersion = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    if ($majorVersion -ge 18) {
        Write-Success "Node.js is already installed: $nodeVersion"
    }
    else {
        Write-Warning "Node.js version $nodeVersion is too old. Need version 18+."
        if (Test-Command "choco") {
            Write-Info "Upgrading Node.js..."
            choco upgrade nodejs -y
        }
        else {
            Write-Warning "Please upgrade Node.js manually to version 18 or higher"
        }
    }
}

# Verify Node.js installation
if (-not (Test-Command "node")) {
    Write-Error "Node.js installation failed. Please install manually and run this script again."
    exit 1
}

if (-not (Test-Command "npm")) {
    Write-Error "npm not found. Please reinstall Node.js."
    exit 1
}

$nodeVersion = node --version
$npmVersion = npm --version
Write-Success "Node.js: $nodeVersion"
Write-Success "npm: $npmVersion"

# Install project dependencies
Write-Info "Installing project dependencies..."
if (-not (Test-Path "package.json")) {
    Write-Error "package.json not found. Make sure you're in the project directory."
    exit 1
}

try {
    npm install
    Write-Success "Project dependencies installed successfully"
}
catch {
    Write-Error "Failed to install project dependencies: $($_.Exception.Message)"
    exit 1
}

# Create .env file from template
Write-Info "Setting up environment configuration..."
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Success "Created .env file from template"
    }
    else {
        Write-Error ".env.example not found"
        exit 1
    }
}
else {
    Write-Info ".env file already exists"
}

# Generate encryption key
Write-Info "Generating encryption key..."
try {
    $encryptionKey = node -e "console.log(require('crypto').randomBytes(16).toString('hex'))"
    
    # Update .env file with generated key
    $envContent = Get-Content ".env" -Raw
    $envContent = $envContent -replace 'N8N_ENCRYPTION_KEY=your_32_character_encryption_key_here', "N8N_ENCRYPTION_KEY=$encryptionKey"
    Set-Content ".env" $envContent -NoNewline
    
    Write-Success "Encryption key generated and added to .env file"
}
catch {
    Write-Warning "Failed to generate encryption key automatically. Please set N8N_ENCRYPTION_KEY manually in .env file."
}

# Validate installation
Write-Info "Validating installation..."
$validationPassed = $true

# Check Docker
if (-not (Test-Command "docker")) {
    Write-Error "Docker validation failed"
    $validationPassed = $false
}

# Check Docker is running
try {
    docker info | Out-Null
}
catch {
    Write-Error "Docker is not running"
    $validationPassed = $false
}

# Check Node.js
if (-not (Test-Command "node")) {
    Write-Error "Node.js validation failed"
    $validationPassed = $false
}

# Check project dependencies
if (-not (Test-Path "node_modules")) {
    Write-Error "Project dependencies not installed"
    $validationPassed = $false
}

# Check .env file
if (-not (Test-Path ".env")) {
    Write-Error ".env file not found"
    $validationPassed = $false
}

if ($validationPassed) {
    Write-Success "All validations passed!"
    Write-Host ""
    Write-Success "✅ Setup completed successfully!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Edit .env file and add your API credentials:" -ForegroundColor White
    Write-Host "   - Reddit API credentials" -ForegroundColor Gray
    Write-Host "   - OpenAI API key" -ForegroundColor Gray
    Write-Host "   - Google Sheets API credentials" -ForegroundColor Gray
    Write-Host "   - Slack webhook URL" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Start the system:" -ForegroundColor White
    Write-Host "   npm run start" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. Access n8n at http://localhost:5678" -ForegroundColor White
    Write-Host ""
}
else {
    Write-Error "Setup validation failed. Please check the errors above."
    exit 1
}

Read-Host "Press Enter to continue"