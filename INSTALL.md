# 🚀 Automated Installation Guide

This guide will help you set up the complete GTM Automation system with **fully automated** Docker and Node.js installation.

## ⚡ One-Command Setup

Choose your preferred method and run **as Administrator**:

### Option 1: PowerShell (Recommended)
```powershell
# Right-click Start Menu → "Windows PowerShell (Admin)"
cd "C:\Users\rithu\projects\GTM Automation"
.\setup.ps1
```

### Option 2: Command Prompt
```cmd
# Right-click Start Menu → "Command Prompt (Admin)"
cd "C:\Users\rithu\projects\GTM Automation"
setup.bat
```

### Option 3: Git Bash/WSL
```bash
cd "C:\Users\rithu\projects\GTM Automation"
./setup.sh
```

## 🤖 What Happens Automatically

### ✅ **Docker Installation**
- **Detects** if Docker is installed
- **Downloads** Docker Desktop installer (700MB+)
- **Installs** Docker Desktop silently
- **Starts** Docker Desktop automatically
- **Waits** for Docker to be ready (up to 3 minutes)

### ✅ **Node.js Installation**
- **Detects** if Node.js 18+ is installed
- **Installs** via Chocolatey (if available) or direct download
- **Verifies** npm is working
- **Updates** environment variables

### ✅ **Project Setup**
- **Installs** all npm dependencies
- **Creates** .env file from template
- **Generates** secure encryption key
- **Validates** entire installation

## ⏱️ Expected Timeline

| Step | Duration | Notes |
|------|----------|-------|
| Chocolatey Install | 2-3 min | If not already installed |
| Docker Download | 5-10 min | Depends on internet speed |
| Docker Install | 3-5 min | Silent installation |
| Docker Startup | 2-3 min | First-time initialization |
| Node.js Install | 2-3 min | If not already installed |
| Dependencies | 1-2 min | npm install |
| **Total** | **15-25 min** | **Completely automated** |

## 🔧 Installation Methods

### Method 1: Chocolatey (Fastest)
- Uses Chocolatey package manager
- Fastest and most reliable
- Automatically handles dependencies

### Method 2: Direct Download (Fallback)
- Downloads installers directly from vendors
- Used when Chocolatey fails
- Still fully automated

## 🎯 After Installation

When setup completes successfully, you'll see:

```
✅ Setup completed successfully!
=============================================

Next steps:
1. Edit .env file and add your API credentials
2. Start the system: npm run start
3. Access n8n at http://localhost:5678
```

## 🔑 Required API Keys

Edit the `.env` file and add:

```bash
# Reddit API (create app at reddit.com/prefs/apps)
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_client_secret

# OpenAI API (get key at platform.openai.com/api-keys)
OPENAI_API_KEY=sk-your_openai_api_key

# Google Sheets API (create service account)
GOOGLE_SHEETS_CLIENT_EMAIL=your-service-account@project.iam.gserviceaccount.com
GOOGLE_SHEETS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"

# Slack Webhook (create at api.slack.com/apps)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK
```

## 🚦 Start the System

```bash
# Start all services
npm run start

# Check logs
npm run logs

# Access n8n
# http://localhost:5678
```

## 🛠️ Troubleshooting

### If Docker Installation Fails:
```powershell
# Manually install Docker Desktop
# Go to: https://www.docker.com/products/docker-desktop/
# Download and run installer as Administrator
```

### If Node.js Installation Fails:
```powershell
# Manually install Node.js
# Go to: https://nodejs.org/
# Download LTS version and install
```

### If Setup Script Fails:
```bash
# Check prerequisites
docker --version
node --version
npm --version

# Retry setup
.\setup.ps1
```

## 📋 Prerequisites

- **Windows 10/11** (64-bit)
- **8GB+ RAM** (recommended)
- **5GB+ free disk space**
- **Administrator privileges**
- **Internet connection**

## 🔒 Security Notes

- Script requires **Administrator privileges** for software installation
- Downloads are from **official sources only**:
  - Docker: `desktop.docker.com`
  - Node.js: `nodejs.org` or Chocolatey
- All installations use **official installers**
- No third-party or unofficial sources

## ✨ Features

- **Zero Manual Intervention**: Completely automated setup
- **Error Handling**: Graceful fallbacks if installations fail
- **Progress Monitoring**: Real-time feedback on installation progress
- **Validation**: Comprehensive checks to ensure everything works
- **Multiple Methods**: Chocolatey, direct download, and manual fallbacks

---

**Ready to automate your GTM processes!** 🎯