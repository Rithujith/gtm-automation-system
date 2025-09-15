# 🤖 AI Providers Guide

Your GTM automation system supports multiple AI providers, including **Claude** (perfect for your Pro subscription!) and several **free alternatives**.

## 🏆 Recommended for Claude Pro Users

### **Claude (Anthropic)** - ⭐ BEST CHOICE
- **Perfect for your Claude Pro subscription!**
- **Superior analysis quality** - Best for nuanced business content
- **Large context window** (200K tokens)
- **Professional responses** - Matches your GTM use case perfectly
- **API Cost**: ~$25/month for typical usage

```bash
# Quick setup for Claude:
AI_PROVIDER=claude
CLAUDE_API_KEY=sk-ant-your_api_key_here
```

## 🆓 Best Free Alternatives

### **1. Groq** - ⚡ FASTEST & FREE
- **Ultra-fast inference** (10x faster than others)
- **Generous free tier**: 14,400 requests/day
- **Great for high-volume processing**
- **Models**: Llama 3.1 70B, Mixtral 8x7B

```bash
AI_PROVIDER=groq
GROQ_API_KEY=gsk_your_api_key_here
```

### **2. Together AI** - 🎯 GOOD BALANCE
- **$25 in free credits** (~5M tokens)
- **Quality models**: Llama 3.1 70B
- **Good for development and testing**

```bash
AI_PROVIDER=together  
TOGETHER_API_KEY=your_api_key_here
```

### **3. Ollama** - 💻 COMPLETELY FREE
- **Run models locally** - Zero API costs
- **Complete privacy** - No data sent externally
- **Requires**: 8GB+ RAM, 50GB+ storage
- **Models**: Llama 3.1, Mistral, CodeLlama

```bash
AI_PROVIDER=ollama
OLLAMA_BASE_URL=http://localhost:11434
```

## 🚀 Quick Setup

### Option 1: Interactive Setup (Recommended)
```bash
npm run setup:ai
```
This will guide you through choosing and configuring a provider.

### Option 2: Manual Setup
1. **Choose your provider** from the table below
2. **Get API key** from provider's website  
3. **Update .env file** with your choice
4. **Restart the system**

## 📊 Provider Comparison

| Provider | Cost | Performance | Setup | Best For |
|----------|------|-------------|-------|----------|
| **Claude** | $25/month | ⭐⭐⭐⭐⭐ | Easy | **Pro users, best quality** |
| **Groq** | Free | ⭐⭐⭐⭐ | Easy | **High volume, speed** |
| **Together** | Free tier | ⭐⭐⭐ | Easy | **Development** |
| **Ollama** | Free | ⭐⭐⭐ | Medium | **Privacy, no limits** |
| OpenAI | $50/month | ⭐⭐⭐⭐⭐ | Easy | Industry standard |

## 🔧 Detailed Setup Instructions

### Claude API (Recommended for you!)
```bash
# 1. Get API key
# Go to: https://console.anthropic.com/
# Create account → API Keys → Create Key

# 2. Update .env file
AI_PROVIDER=claude
CLAUDE_API_KEY=sk-ant-your_key_here
CLAUDE_MODEL=claude-3-5-sonnet-20241022
```

### Groq API (Best Free Option)
```bash
# 1. Get API key  
# Go to: https://console.groq.com/keys
# Create account → API Keys → Create API Key

# 2. Update .env file
AI_PROVIDER=groq
GROQ_API_KEY=gsk_your_key_here
GROQ_MODEL=llama-3.1-70b-versatile
```

### Together AI
```bash
# 1. Get API key
# Go to: https://api.together.xyz/settings/api-keys
# Create account → API Keys → Create Key

# 2. Update .env file  
AI_PROVIDER=together
TOGETHER_API_KEY=your_key_here
TOGETHER_MODEL=meta-llama/Meta-Llama-3.1-70B-Instruct-Turbo
```

### Ollama (Local Setup)
```bash
# 1. Install Ollama
# Download from: https://ollama.ai/download
# Install and start the service

# 2. Install a model
ollama pull llama3.1:8b  # 4.7GB download
# or
ollama pull llama3.1:70b # 40GB download (better quality)

# 3. Update .env file
AI_PROVIDER=ollama
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3.1:8b
```

## 💰 Cost Estimates (Monthly)

### For typical GTM automation usage (~50K tokens/day):

| Provider | Cost | Notes |
|----------|------|-------|
| **Claude** | **$25** | **Perfect quality for GTM** |
| **Groq** | **$0** | **Free tier covers most usage** |
| **Together** | **$0** | **Free credits last months** |
| **Ollama** | **$0** | **Completely free forever** |
| OpenAI | $50 | More expensive |

## 🎯 Which Should You Choose?

### **For Claude Pro Users (YOU!):**
✅ **Claude API** - Best quality, matches your existing subscription  
✅ **Groq** - Free backup for high-volume testing  

### **For Budget-Conscious Users:**
✅ **Groq** - Generous free tier, very fast  
✅ **Ollama** - Completely free, runs locally  

### **For Privacy-Focused:**
✅ **Ollama** - Everything runs on your machine  

## 🔄 Switching Providers

You can easily switch between providers:

```bash
# In your .env file, just change:
AI_PROVIDER=claude    # Switch to Claude
AI_PROVIDER=groq      # Switch to Groq  
AI_PROVIDER=ollama    # Switch to Ollama

# Then restart:
npm run restart
```

## 🧪 Testing Your Setup

After configuring a provider, test it:

```bash
# Start the system
npm run start

# Check logs for AI provider initialization
npm run logs:n8n

# Look for messages like:
# "AI Provider: claude initialized successfully"
# "Model: claude-3-5-sonnet-20241022 ready"
```

## 🚨 Troubleshooting

### Claude API Issues
```bash
# Check API key format
CLAUDE_API_KEY=sk-ant-...  # Must start with sk-ant-

# Check model name
CLAUDE_MODEL=claude-3-5-sonnet-20241022  # Exact spelling
```

### Groq API Issues  
```bash
# Check API key format
GROQ_API_KEY=gsk_...  # Must start with gsk_

# Check rate limits (30 req/min on free tier)
```

### Ollama Issues
```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Restart Ollama service
ollama serve

# Check installed models
ollama list
```

## 📈 Performance Tips

### **For High Volume:**
- Use **Groq** (fastest inference)
- Enable caching in n8n workflows
- Batch multiple posts in single requests

### **For Best Quality:**
- Use **Claude** with detailed prompts
- Increase max_tokens for complex analysis
- Use temperature=0.3 for consistent results

### **For Cost Optimization:**
- Start with **Groq free tier**
- Use **Ollama** for development
- Switch to **Claude** for production

---

**Ready to analyze Reddit posts with AI!** 🎯

Choose your provider and let's start monitoring for GTM opportunities!