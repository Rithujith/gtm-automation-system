# 📊 Google Sheets Integration Setup Guide

## Overview
This guide will help you set up Google Sheets integration for the GTM Automation system. The workflow will automatically write analyzed Reddit posts to a Google Spreadsheet.

## 🚀 Quick Setup Steps

### 1. Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click "New Project" or select an existing one
3. Note your project ID

### 2. Enable Google Sheets API
1. In the Google Cloud Console, go to "APIs & Services" > "Library"
2. Search for "Google Sheets API"
3. Click on it and press "Enable"

### 3. Create Service Account
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "Service Account"
3. Enter a name like "gtm-automation-sheets"
4. Click "Create and Continue"
5. Skip the optional steps and click "Done"

### 4. Generate Service Account Key
1. In the Credentials page, click on your newly created service account
2. Go to the "Keys" tab
3. Click "Add Key" > "Create New Key"
4. Select "JSON" format and click "Create"
5. Download the JSON file securely

### 5. Extract Credentials from JSON
From the downloaded JSON file, extract these values:
```json
{
  "client_email": "gtm-automation-sheets@your-project.iam.gserviceaccount.com",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
}
```

### 6. Create Google Spreadsheet
1. Go to [Google Sheets](https://sheets.google.com)
2. Create a new spreadsheet
3. Name it "GTM Automation Data"
4. Copy the spreadsheet ID from the URL:
   ```
   https://docs.google.com/spreadsheets/d/SPREADSHEET_ID_HERE/edit
   ```

### 7. Share Spreadsheet with Service Account
1. In your Google Sheet, click "Share"
2. Add the service account email (from step 5)
3. Give it "Editor" permissions
4. Click "Send"

### 8. Update Environment Variables
Edit your `.env` file with the extracted values:

```bash
# Google Sheets API Configuration
GOOGLE_SHEETS_CLIENT_EMAIL=gtm-automation-sheets@your-project.iam.gserviceaccount.com
GOOGLE_SHEETS_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----"
GOOGLE_SHEETS_SPREADSHEET_ID=your_spreadsheet_id_from_url
GOOGLE_SHEETS_SHEET_NAME=GTM_Data
```

## 📋 Google Sheets Schema

The workflow will create the following columns automatically:

| Column | Description | Example |
|--------|-------------|---------|
| Timestamp | When the post was processed | 2025-01-15T10:30:00Z |
| Platform | Source platform | Reddit |
| Post URL | Direct link to post | https://reddit.com/r/entrepreneur/... |
| Title | Post title | "Need help with customer retention" |
| Author | Reddit username | u/entrepreneur123 |
| Subreddit | Subreddit name | r/entrepreneur |
| Upvotes | Number of upvotes | 45 |
| Comments | Number of comments | 12 |
| Content Preview | First 200 characters | "I'm struggling with keeping customers..." |
| Relevance Score | AI relevance score (0-100) | 85 |
| Intent | AI-classified intent | question |
| Sentiment | AI-detected sentiment | neutral |
| Business Context | AI-generated context summary | "User seeking retention strategies..." |
| Engagement Recommendation | AI recommendation | direct_reply |
| Priority | Priority level | high |
| Confidence | AI confidence score | 92 |
| Key Pain Points | JSON array of issues | ["high churn", "low retention"] |
| Potential Solutions | JSON array of solutions | ["email campaigns", "loyalty program"] |
| Follow-up Strategy | AI-suggested approach | "Offer retention consultation" |
| AI Provider | AI service used | google |
| Status | Processing status | New |

## 🔧 Testing the Integration

### 1. Restart n8n Services
```bash
docker compose restart n8n
```

### 2. Import Updated Workflow
1. Open n8n at http://localhost:5678
2. Import the updated `workflows/reddit-monitoring-google-ai.json`
3. Activate the workflow

### 3. Manual Test
1. In n8n, click "Execute Workflow" on the Schedule Trigger
2. Monitor the execution
3. Check your Google Sheet for new data

### 4. Verify Automatic Operation
- The workflow runs every 15 minutes
- Check the Google Sheet periodically for new entries
- All analyzed Reddit posts will appear in the sheet

## 🛠️ Troubleshooting

### Common Issues

**"Insufficient permissions" error:**
- Ensure the service account email has Editor access to the spreadsheet
- Double-check the spreadsheet is shared correctly

**"Invalid credentials" error:**
- Verify the private key is properly formatted in the .env file
- Ensure the client_email matches exactly

**"Spreadsheet not found" error:**
- Check the SPREADSHEET_ID is correct
- Ensure the spreadsheet exists and is accessible

**"Sheet not found" error:**
- The workflow will create the sheet automatically
- Ensure GOOGLE_SHEETS_SHEET_NAME matches your desired sheet name

### Debug Steps
1. Check n8n execution logs for detailed error messages
2. Verify all environment variables are set correctly
3. Test credentials manually using Google Sheets API explorer
4. Ensure the spreadsheet URL is accessible

## 🔒 Security Best Practices

1. **Keep credentials secure**: Never commit the private key to version control
2. **Use service accounts**: Don't use personal Google accounts for automation
3. **Limit permissions**: Only grant necessary access to the spreadsheet
4. **Regular rotation**: Consider rotating service account keys periodically
5. **Monitor usage**: Check Google Cloud Console for API usage and billing

## 📈 Data Analysis

Once data starts flowing to Google Sheets, you can:

1. **Create pivot tables** to analyze trends by subreddit, sentiment, or intent
2. **Build charts** to visualize relevance scores over time
3. **Filter and sort** to focus on high-priority opportunities
4. **Export data** for external analysis tools
5. **Share insights** with team members who have spreadsheet access

## 🔄 Integration Benefits

**Dual Storage Strategy:**
- **PostgreSQL**: Structured data for applications and complex queries
- **Google Sheets**: Easy access, sharing, and business user analysis

**Business Value:**
- Immediate visibility into opportunities
- Easy data sharing with non-technical team members
- Built-in Google Workspace integration
- Simple filtering and sorting capabilities
- Real-time collaboration features

---

The Google Sheets integration is now ready! Your GTM automation system will write all analyzed Reddit posts to both the PostgreSQL database and Google Sheets, giving you the best of both worlds for data storage and analysis.