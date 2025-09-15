# 🚀 GTM Automation System

**Professional Reddit monitoring and AI-powered lead qualification system built with n8n workflows.**

## 🎬 **Video Demonstration**
**Watch the complete system walkthrough and demo**: [GTM Automation System Demo](https://youtu.be/E3kZ08f4K3A)

## ⚠️ **Demo Credentials Notice**
**This repository contains live API credentials for demonstration purposes only. These credentials will be removed immediately after the demo presentation. In production, all sensitive credentials should be stored securely using environment variables and never committed to version control.**

## 🎯 System Overview

This GTM automation system monitors Reddit for business opportunities, analyzes posts with AI, and automatically stores qualified leads in a database with Slack notifications for high-priority opportunities.

### 🏗️ Architecture

- **n8n** - Workflow automation platform
- **PostgreSQL** - Data storage and analytics
- **Google AI (Gemini)** - Post analysis and classification
- **Redis** - Queue management and caching
- **Slack** - Real-time notifications
- **Docker** - Containerized deployment

## ✨ Key Features

### 🔍 **Intelligent Monitoring**
- Monitors multiple subreddits every 15 minutes
- Advanced keyword filtering with semantic matching
- Duplicate detection and prevention

### 🤖 **AI-Powered Analysis**
- Relevance scoring (0-100)
- Intent classification (question/complaint/vendor_search/discussion/showcase)
- Sentiment analysis (positive/negative/neutral/frustrated)
- Business context extraction
- Engagement recommendations

### 📊 **Data Management**
- Structured PostgreSQL database for applications
- Google Sheets integration for business users
- Complete audit trail with timestamps
- Scalable schema for analytics
- Automated data validation and dual storage

### 🔔 **Smart Notifications**
- Slack alerts for high-priority opportunities
- Rich message formatting with post details
- Configurable priority thresholds

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone <repository>
cd GTM\ Automation
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your API keys:
# - GOOGLE_AI_API_KEY
# - SLACK_WEBHOOK_URL
# - GOOGLE_SHEETS_SPREADSHEET_ID (optional)
# - Database credentials
```

### 3. Start Services
```bash
docker compose up -d
```

### 4. Access n8n
- Open: http://localhost:5678
- Login with credentials from .env file
- Import workflow: `workflows/reddit-monitoring-google-ai.json`

### 5. Activate Workflow
- Set the imported workflow to "Active"
- Monitor execution in n8n dashboard

## 📋 Configuration

This system monitors Reddit for business opportunities related to customer retention, churn reduction, and ecommerce growth. It uses OpenAI for intelligent post classification and generates personalized engagement suggestions, storing results in Google Sheets with Slack notifications.

## 🏗️ Architecture

```
├── workflows/          # n8n workflow JSON files
├── config/            # Configuration files and settings
├── docker/            # Docker deployment files
├── docs/              # Documentation and guides
├── scripts/           # Utility scripts
├── docker-compose.yml # Main deployment configuration
├── .env.example       # Environment variables template
└── package.json       # Dependencies and scripts
```

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose
- Node.js 18+ (for utility scripts)
- Reddit API credentials
- OpenAI API key
- Google Sheets API credentials
- Slack webhook URL

### 1. Clone and Setup

```bash
git clone <repository-url>
cd gtm-automation
cp .env.example .env
```

### 2. Configure Environment

Edit `.env` file with your API credentials:

```bash
# Required API Keys
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_client_secret
OPENAI_API_KEY=sk-your_openai_api_key
GOOGLE_SHEETS_CLIENT_EMAIL=your-service-account@project.iam.gserviceaccount.com
GOOGLE_SHEETS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK

# Generate a secure encryption key (32 characters)
N8N_ENCRYPTION_KEY=your_32_character_encryption_key
```

### 3. Start the System

```bash
# Start all services
npm run start

# View logs
npm run logs

# Stop services
npm run stop
```

### 4. Access n8n

- Open http://localhost:5678
- Login with credentials from `.env` file
- Import workflows from `workflows/` directory

## 📁 Configuration Files

### Keywords Configuration (`config/keywords.json`)
- **Primary Keywords**: Business terms with weights and priorities
- **Semantic Groups**: Related terms for better matching
- **Negative Keywords**: Terms to avoid
- **Quality Filters**: Post quality requirements

### Subreddit Configuration (`config/subreddit-config.json`)
- **Subreddit Settings**: Check frequencies and priorities
- **Engagement Rules**: Response guidelines per subreddit
- **Content Filters**: Post filtering criteria
- **Time-based Adjustments**: Peak hours optimization

### AI Prompts (`config/ai-prompts.json`)
- **Classification Prompts**: For post relevance scoring
- **Engagement Prompts**: For response generation
- **Sentiment Analysis**: Emotional context detection
- **Quality Assessment**: Spam and authenticity detection

## 🔧 Available Scripts

```bash
# Docker Management
npm run start          # Start all services
npm run stop           # Stop all services  
npm run restart        # Restart services
npm run logs           # View all logs
npm run logs:n8n       # View n8n logs only

# Workflow Management
npm run import:workflows    # Import n8n workflows
npm run export:workflows    # Export n8n workflows
npm run validate:config     # Validate configuration files

# Maintenance
npm run backup         # Backup system data
npm run restore        # Restore from backup
npm run health         # System health check

# Development
npm run dev            # Development mode
npm run test           # Run tests
npm run lint           # Code linting
```

## 📊 Data Schema

### Google Sheets Structure
| Column | Description |
|--------|-------------|
| Timestamp | When post was processed |
| Platform | Reddit/LinkedIn |
| Post URL | Direct link to post |
| Title | Post title |
| Summary | AI-generated summary |
| Relevance Score | 0-100 relevance rating |
| Intent | Question/Complaint/Vendor Search |
| Sentiment | Positive/Negative/Neutral |
| Engagement Suggestion | Recommended response |
| Priority | High/Medium/Low |
| Status | New/Engaged/Closed |

## 🔔 Notification System

### Slack Alerts
- **High Priority**: Relevance score > 80
- **Real-time Notifications**: Immediate alerts for urgent opportunities
- **Daily Summaries**: Aggregate reports
- **Error Alerts**: System health monitoring

### Alert Thresholds
- **High Priority**: Score ≥ 80 (immediate Slack notification)
- **Medium Priority**: Score 60-79 (included in daily summary)
- **Low Priority**: Score < 60 (logged only)

## 🛡️ Security Features

- **API Key Management**: Secure storage and rotation
- **Rate Limiting**: Compliance with platform limits
- **Request Validation**: Input sanitization
- **Access Logging**: Complete audit trail
- **Webhook Verification**: Secure webhook handling

## 📈 Monitoring & Analytics

### Key Metrics
- **Posts Processed**: Volume tracking
- **Relevance Distribution**: Quality metrics
- **Engagement Success Rate**: Response effectiveness
- **API Usage**: Cost and rate limit monitoring
- **System Performance**: Response times and uptime

### Health Monitoring
- **Service Health**: Automatic health checks
- **Database Connectivity**: PostgreSQL and Redis monitoring
- **API Endpoint Status**: External service monitoring
- **Queue Performance**: Background job monitoring

## 🚨 Troubleshooting

### Common Issues

**n8n Won't Start**
```bash
# Check logs
docker-compose logs n8n

# Verify database connection
docker-compose logs postgres

# Reset and restart
docker-compose down -v
docker-compose up -d
```

**API Rate Limits**
- Check rate limiting configuration in `config/app-config.json`
- Monitor API usage in logs
- Adjust check frequencies in subreddit config

**Database Connection Issues**
```bash
# Check PostgreSQL status
docker-compose ps postgres

# Reset database
docker-compose down -v
docker volume rm gtm-automation_postgres_data
docker-compose up -d
```

### Log Locations
- **n8n Logs**: `docker-compose logs n8n`
- **Database Logs**: `docker-compose logs postgres`
- **Redis Logs**: `docker-compose logs redis`
- **System Logs**: `/var/log/n8n/` (inside container)

## 🔧 Development

### Local Development
```bash
# Install dependencies
npm install

# Start development environment
npm run dev

# Run tests
npm run test

# Code quality
npm run lint
npm run format
```

### Adding New Workflows
1. Create workflow in n8n interface
2. Export as JSON
3. Save to `workflows/` directory
4. Update documentation

### Configuration Updates
1. Modify files in `config/` directory
2. Restart n8n service: `docker-compose restart n8n`
3. Validate changes: `npm run validate:config`

## 📚 Documentation

- **Setup Guide**: `docs/setup-guide.md`
- **API Configuration**: `docs/api-configuration.md`
- **Google Sheets Setup**: `docs/google-sheets-setup.md`
- **Workflow Guide**: `docs/workflow-guide.md`
- **Troubleshooting**: `docs/troubleshooting.md`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes with tests
4. Submit pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🆘 Support

For issues and questions:
- Check troubleshooting guide
- Review logs for error messages
- Open GitHub issue with details

---

**Built for professional GTM automation with enterprise-ready features and comprehensive monitoring.**

---

## 🔒 **Security Notice**
- **Demo credentials included**: This repository contains working API credentials for demonstration purposes
- **Production security**: In real deployments, use environment variables and secure credential management
- **Post-demo cleanup**: All credentials will be rotated/removed after demonstration