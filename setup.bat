@echo off
REM GTM Automation Setup Script for Windows
REM Automatically installs Docker, Node.js, and project dependencies

setlocal enabledelayedexpansion

REM Colors (limited in Windows batch)
set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

echo %INFO% Starting GTM Automation Setup for Windows...
echo =============================================

REM Check if Docker is installed
echo %INFO% Checking Docker installation...
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %INFO% Docker not found. Installing Docker Desktop automatically...
    
    REM Try chocolatey first
    where choco >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        echo %INFO% Installing Docker Desktop via Chocolatey...
        choco install docker-desktop -y --limit-output
        
        REM Refresh PATH
        call refreshenv
        
        where docker >nul 2>nul
        if %ERRORLEVEL% EQU 0 (
            echo %SUCCESS% Docker Desktop installed via Chocolatey
            goto start_docker
        )
    )
    
    REM Fallback to direct download
    echo %INFO% Downloading Docker Desktop installer...
    powershell -Command "Invoke-WebRequest -Uri 'https://desktop.docker.com/win/main/amd64/Docker%%20Desktop%%20Installer.exe' -OutFile '%TEMP%\DockerDesktopInstaller.exe' -UseBasicParsing"
    
    if exist "%TEMP%\DockerDesktopInstaller.exe" (
        echo %INFO% Installing Docker Desktop ^(this may take several minutes^)...
        "%TEMP%\DockerDesktopInstaller.exe" install --quiet --accept-license
        
        if %ERRORLEVEL% EQU 0 (
            echo %SUCCESS% Docker Desktop installed successfully
            del "%TEMP%\DockerDesktopInstaller.exe" >nul 2>nul
            
            REM Add Docker to PATH
            set "PATH=%PATH%;%ProgramFiles%\Docker\Docker\resources\bin"
            
            :start_docker
            echo %INFO% Starting Docker Desktop...
            start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
            
            echo %INFO% Waiting for Docker Desktop to initialize...
            set /a timeout=120
            set /a elapsed=0
            
            :wait_docker
            timeout /t 5 /nobreak >nul
            set /a elapsed+=5
            
            docker info >nul 2>nul
            if %ERRORLEVEL% EQU 0 (
                echo %SUCCESS% Docker Desktop is ready!
                goto docker_ready
            )
            
            if %elapsed% LSS %timeout% (
                echo %INFO% Docker starting... ^(%elapsed%/%timeout% seconds^)
                goto wait_docker
            )
            
            echo %WARNING% Docker Desktop is taking longer than expected to start.
            echo %INFO% Please wait for Docker Desktop to fully load and try again.
            pause
        ) else (
            echo %ERROR% Docker Desktop installation failed
            del "%TEMP%\DockerDesktopInstaller.exe" >nul 2>nul
            echo Please install Docker Desktop manually from https://www.docker.com/products/docker-desktop/
            pause
            exit /b 1
        )
    ) else (
        echo %ERROR% Failed to download Docker Desktop installer
        echo Please install Docker Desktop manually from https://www.docker.com/products/docker-desktop/
        pause
        exit /b 1
    )
) else (
    for /f "tokens=*" %%i in ('docker --version 2^>nul') do set DOCKER_VERSION=%%i
    echo %SUCCESS% Docker is installed: !DOCKER_VERSION!
    
    REM Check if Docker is running
    docker info >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo %INFO% Starting Docker Desktop...
        start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
        
        echo %INFO% Waiting for Docker to start...
        :wait_docker_start
        timeout /t 5 /nobreak >nul
        docker info >nul 2>nul
        if %ERRORLEVEL% NEQ 0 (
            goto wait_docker_start
        )
    )
)

:docker_ready
echo %SUCCESS% Docker is running

REM Check if Node.js is installed
echo %INFO% Checking Node.js installation...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %WARNING% Node.js not found. Installing via Chocolatey...
    
    REM Check if chocolatey is installed
    where choco >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo %WARNING% Chocolatey not found. Please install Node.js manually:
        echo 1. Go to https://nodejs.org/
        echo 2. Download the LTS version for Windows
        echo 3. Run the installer
        echo 4. Restart this command prompt
        echo.
        pause
        goto check_node_again
    ) else (
        echo %INFO% Installing Node.js via Chocolatey...
        choco install nodejs -y
    )
) else (
    for /f "tokens=*" %%i in ('node --version 2^>nul') do set NODE_VERSION=%%i
    echo %SUCCESS% Node.js is installed: !NODE_VERSION!
)

:check_node_again
REM Verify Node.js installation
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% Node.js installation failed. Please install manually and run this script again.
    pause
    exit /b 1
)

REM Check npm
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% npm not found. Please reinstall Node.js.
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version 2^>nul') do set NODE_VERSION=%%i
for /f "tokens=*" %%i in ('npm --version 2^>nul') do set NPM_VERSION=%%i
echo %SUCCESS% Node.js: !NODE_VERSION!
echo %SUCCESS% npm: !NPM_VERSION!

REM Install project dependencies
echo %INFO% Installing project dependencies...
if not exist package.json (
    echo %ERROR% package.json not found. Make sure you're in the project directory.
    pause
    exit /b 1
)

npm install
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% Failed to install project dependencies
    pause
    exit /b 1
)
echo %SUCCESS% Project dependencies installed successfully

REM Create .env file from template
echo %INFO% Setting up environment configuration...
if not exist .env (
    if exist .env.example (
        copy .env.example .env >nul
        echo %SUCCESS% Created .env file from template
    ) else (
        echo %ERROR% .env.example not found
        pause
        exit /b 1
    )
) else (
    echo %INFO% .env file already exists
)

REM Generate encryption key using Node.js
echo %INFO% Generating encryption key...
for /f "tokens=*" %%i in ('node -e "console.log(require('crypto').randomBytes(16).toString('hex'))" 2^>nul') do set ENCRYPTION_KEY=%%i

REM Update .env file with generated key
powershell -Command "(gc .env) -replace 'N8N_ENCRYPTION_KEY=your_32_character_encryption_key_here', 'N8N_ENCRYPTION_KEY=%ENCRYPTION_KEY%' | Out-File -encoding ASCII .env"
echo %SUCCESS% Encryption key generated and added to .env file

REM Validate installation
echo %INFO% Validating installation...

REM Check Docker
docker --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% Docker validation failed
    goto validation_failed
)

REM Check Docker is running
docker info >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% Docker is not running
    goto validation_failed
)

REM Check Node.js
node --version >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %ERROR% Node.js validation failed
    goto validation_failed
)

REM Check project dependencies
if not exist node_modules (
    echo %ERROR% Project dependencies not installed
    goto validation_failed
)

REM Check .env file
if not exist .env (
    echo %ERROR% .env file not found
    goto validation_failed
)

echo %SUCCESS% All validations passed!

echo.
echo %SUCCESS% ✅ Setup completed successfully!
echo =============================================
echo.
echo Next steps:
echo 1. Edit .env file and add your API credentials:
echo    - Reddit API credentials
echo    - OpenAI API key
echo    - Google Sheets API credentials
echo    - Slack webhook URL
echo.
echo 2. Start the system:
echo    npm run start
echo.
echo 3. Access n8n at http://localhost:5678
echo.
pause
exit /b 0

:validation_failed
echo %ERROR% Setup validation failed. Please check the errors above.
pause
exit /b 1