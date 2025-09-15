# 🎬 GTM Automation System - Video Demo Script

## 📋 **Video Structure Overview**
**Total Duration**: 8-10 minutes
- **Personal Introduction**: 2-3 minutes
- **Technical Walkthrough**: 5-7 minutes

---

## 🎯 **Part 1: Personal Introduction (2-3 minutes)**

### **Opening Hook (30 seconds)**
> "Hi! I'm [Your Name], and I'm excited to show you a GTM automation system I built that can identify high-value business opportunities on Reddit in real-time, analyze them with AI, and automatically prepare engagement strategies. This isn't just another keyword scraper - it's an intelligent lead qualification pipeline."

### **Background & Expertise (90 seconds)**
> "My background spans automation, data analysis, and growth marketing. I've worked with [mention relevant experience], and I'm passionate about building systems that bridge the gap between technical capabilities and real business impact.
>
> What excites me about GTM automation is the opportunity to transform how teams discover and engage with potential customers. Instead of manually browsing social platforms hoping to find relevant discussions, we can create intelligent systems that work 24/7, surface the best opportunities, and even suggest how to engage authentically.
>
> This project demonstrates my approach to building production-ready automation - not just proof of concepts, but systems you'd actually deploy and rely on."

### **Problem Context (30 seconds)**
> "For this assignment, I focused on Reddit because it's where authentic business discussions happen. The challenge was building something that goes beyond simple keyword matching to actually understand business context and intent - the difference between someone casually mentioning 'customer churn' and someone actively seeking solutions."

---

## 🔧 **Part 2: Technical Walkthrough (5-7 minutes)**

### **System Architecture Overview (60 seconds)**
> "Let me show you what I built. This is a complete GTM automation pipeline using n8n as the orchestration platform, with five key components:
>
> [**Screen: Show n8n workflow diagram**]
>
> 1. **Reddit API Integration** - Fetches latest posts every 15 minutes
> 2. **Intelligent Filtering** - Advanced keyword matching with semantic groups
> 3. **AI Analysis** - Google Gemini classifies intent, sentiment, and business relevance
> 4. **Dual Storage** - PostgreSQL for applications, Google Sheets for business users
> 5. **Smart Notifications** - Slack alerts for high-priority opportunities
>
> The entire system runs in Docker containers, making it production-ready and easily deployable."

### **Live Demo: Reddit Monitoring (90 seconds)**
> "Let's see this in action. I'll trigger the workflow manually to show you how it works.
>
> [**Screen: n8n workflow execution**]
>
> First, it connects to Reddit and fetches the latest posts from entrepreneurship subreddits. Watch the Filter node - it's not just looking for exact keyword matches. I've implemented semantic groups, so it catches phrases like 'customers leaving' even when someone doesn't explicitly say 'churn reduction.'
>
> [**Screen: Show filter output**]
>
> Here's what it found - [X] relevant posts out of [Y] total. Notice how it's filtering out job postings and spam, focusing only on business discussions."

### **AI Analysis Deep Dive (90 seconds)**
> "Now comes the AI magic. Each relevant post goes through Google Gemini for analysis.
>
> [**Screen: Show AI analysis results**]
>
> Look at this analysis - it's not just a relevance score. The AI is identifying:
> - **Intent classification**: Is this a question, complaint, or vendor search?
> - **Sentiment analysis**: Frustrated, neutral, or positive?
> - **Business context**: What specific challenges are they facing?
> - **Pain points extraction**: Structured data about their problems
> - **Engagement recommendations**: How should we respond?
>
> This post scored [X]/100 for relevance because [explain reasoning]. The AI identified it as a 'question' with 'frustrated' sentiment, suggesting a direct reply approach."

### **Data Storage & Sheets Integration (60 seconds)**
> "The system stores everything in two places for maximum flexibility.
>
> [**Screen: Show Google Sheets**]
>
> Business users get this Google Sheet with clean, actionable data. Each row is a qualified opportunity with the post URL, relevance score, and AI-generated engagement suggestion. The marketing team can immediately see which posts deserve attention.
>
> [**Screen: Show database query**]
>
> For developers and analytics, everything's in PostgreSQL with full structured data including JSON fields for complex analysis."

### **Smart Notifications (45 seconds)**
> "When a high-priority opportunity appears - anything scoring above 70 with high confidence - the system immediately sends a Slack notification.
>
> [**Screen: Show Slack notification**]
>
> Look at this alert - it includes the post title, relevance score, and a direct link. The team can respond within minutes instead of discovering opportunities days later."

### **Production Features (45 seconds)**
> "This isn't just a demo - it's built for production use:
> - **Duplicate prevention**: Won't reprocess the same posts
> - **Error handling**: Graceful fallbacks when APIs fail
> - **Rate limiting**: Respects platform guidelines
> - **Monitoring**: Complete logging and health checks
> - **Security**: No hardcoded credentials, proper environment variables"

### **Business Impact Demonstration (30 seconds)**
> "Let me show you the business value. In just [time period], the system has:
> - Processed [X] posts automatically
> - Identified [Y] high-quality opportunities
> - Saved approximately [Z] hours of manual monitoring
> - Delivered opportunities with an average relevance score of [score]
>
> This transforms a manual, time-consuming process into an automated competitive advantage."

---

## 🎯 **Closing & Differentiators (30 seconds)**

> "What makes this solution special isn't just the technology - it's the business thinking. This system understands context, not just keywords. It provides actionable insights, not just data dumps. And it's built to scale and evolve.
>
> The code is on GitHub, fully documented, and ready to deploy. I'd love to discuss how this approach could be adapted for your specific GTM needs. Thank you!"

---

## 📝 **Demo Preparation Checklist**

### **Before Recording:**
- [ ] Ensure Docker containers are running
- [ ] Verify n8n workflow is active
- [ ] Prepare test Reddit posts or use recent real examples
- [ ] Check Google Sheets has sample data
- [ ] Verify Slack notifications are working
- [ ] Prepare GitHub repository view
- [ ] Test all screen recordings/transitions

### **Key Metrics to Highlight:**
- Number of posts processed
- Relevance score distribution
- Time savings vs manual monitoring
- Accuracy of AI classifications
- Response time from post to notification

### **Technical Details to Mention:**
- Google Gemini 1.5 Flash for AI analysis
- PostgreSQL with JSONB for complex data
- n8n Code nodes for custom logic
- Docker deployment for production
- Environment variable security

### **Business Value Points:**
- Real-time opportunity discovery
- Intelligent qualification vs keyword spam
- Actionable engagement suggestions
- Team collaboration through Sheets/Slack
- Scalable automation platform

---

## 🎬 **Presentation Tips**

1. **Energy & Pace**: Keep it conversational but focused
2. **Show, Don't Tell**: Live demos are more powerful than explanations
3. **Business Focus**: Always connect technical features to business value
4. **Confidence**: This is production-ready software, present it that way
5. **Authenticity**: Acknowledge any limitations or areas for improvement

---

## 📱 **Screen Recording Setup**

### **Recommended Flow:**
1. **Introduction**: Just you talking (webcam)
2. **Architecture**: n8n workflow overview (screen)
3. **Live Demo**: Workflow execution (screen)
4. **Results**: Google Sheets + Slack (screen)
5. **GitHub**: Repository overview (screen)
6. **Closing**: Back to webcam

### **Quality Settings:**
- 1080p minimum resolution
- Clear audio (test beforehand)
- Smooth transitions between screens
- Highlight mouse clicks/important areas

This script positions you as someone who understands both the technical implementation and the business impact - exactly what they're looking for in a GTM automation role!