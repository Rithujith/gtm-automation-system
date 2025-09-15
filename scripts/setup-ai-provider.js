#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Load AI providers configuration
const providersConfig = JSON.parse(
  fs.readFileSync(path.join(__dirname, '..', 'config', 'ai-providers.json'), 'utf8')
);

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function question(prompt) {
  return new Promise((resolve) => {
    rl.question(prompt, resolve);
  });
}

function displayProviders() {
  console.log('\n🤖 Available AI Providers:\n');
  
  Object.entries(providersConfig.providers).forEach(([key, provider], index) => {
    const costBadge = provider.cost === 'free' ? '🆓 FREE' : 
                     provider.cost === 'free_tier' ? '✨ FREE TIER' : '💳 PAID';
    const perfBadge = provider.performance === 'excellent' ? '🚀 EXCELLENT' :
                     provider.performance === 'very_fast' ? '⚡ VERY FAST' :
                     provider.performance === 'good' ? '✅ GOOD' : '⭐ VARIABLE';
    
    console.log(`${index + 1}. ${provider.name} ${costBadge} ${perfBadge}`);
    console.log(`   ${provider.description}`);
    
    if (provider.cost === 'free_tier' && provider.pricing?.free_tier) {
      const freeTier = provider.pricing.free_tier;
      if (freeTier.requests_per_day) {
        console.log(`   Free: ${freeTier.requests_per_day.toLocaleString()} requests/day`);
      }
      if (freeTier.credits) {
        console.log(`   Free: $${freeTier.credits} credits (~${(freeTier.equivalent_tokens/1000000).toFixed(1)}M tokens)`);
      }
    }
    
    if (provider.cost === 'paid' && provider.pricing) {
      const pricing = provider.pricing.gpt4_turbo || provider.pricing;
      if (pricing.input_tokens) {
        console.log(`   Cost: $${pricing.input_tokens}/1K input, $${pricing.output_tokens}/1K output`);
      }
    }
    
    console.log('');
  });
}

function displayRecommendations() {
  console.log('🎯 Recommendations:\n');
  
  const recs = providersConfig.recommendations;
  console.log(`🏆 Best Overall: ${providersConfig.providers[recs.best_overall].name}`);
  console.log(`🆓 Best Free: ${providersConfig.providers[recs.best_free].name}`);
  console.log(`⚡ Fastest: ${providersConfig.providers[recs.fastest].name}`);
  console.log(`💰 Most Cost Effective: ${providersConfig.providers[recs.most_cost_effective].name}`);
  console.log(`🎮 Easiest Setup: ${providersConfig.providers[recs.easiest_setup].name}`);
  console.log('');
}

function displaySetupInstructions(providerKey) {
  const provider = providersConfig.providers[providerKey];
  
  console.log(`\n📋 Setup Instructions for ${provider.name}:\n`);
  
  if (provider.type === 'local') {
    console.log('🖥️  LOCAL SETUP REQUIRED:');
    console.log(`1. Download and install Ollama from: ${provider.setup.installation_url}`);
    console.log('2. Install a model: ollama pull llama3.1:8b');
    console.log('3. Start Ollama service (usually starts automatically)');
    console.log(`4. Set OLLAMA_BASE_URL=${provider.setup.default_url} in your .env file`);
    
    if (provider.requirements) {
      console.log('\n💻 System Requirements:');
      console.log(`   RAM: ${provider.requirements.ram_minimum} minimum, ${provider.requirements.ram_recommended} recommended`);
      console.log(`   Storage: ${provider.requirements.storage}`);
      console.log(`   CPU: ${provider.requirements.cpu}`);
    }
  } else {
    console.log('🌐 API KEY SETUP:');
    console.log(`1. Go to: ${provider.setup.api_key_url}`);
    console.log('2. Create an account or log in');
    console.log('3. Generate an API key');
    console.log(`4. Copy the key (format: ${provider.setup.key_format})`);
    console.log(`5. Add ${provider.setup.environment_var}=your_key_here to your .env file`);
    
    if (provider.cost === 'free_tier') {
      console.log('\n🆓 FREE TIER BENEFITS:');
      if (provider.pricing?.free_tier?.requests_per_day) {
        console.log(`   ${provider.pricing.free_tier.requests_per_day.toLocaleString()} requests per day`);
      }
      if (provider.pricing?.free_tier?.credits) {
        console.log(`   $${provider.pricing.free_tier.credits} in free credits`);
      }
      if (provider.rate_limits) {
        console.log(`   ${provider.rate_limits.requests_per_minute} requests per minute`);
      }
    }
  }
  
  console.log(`\n6. Set AI_PROVIDER=${providerKey} in your .env file`);
  console.log(`7. Restart your n8n workflows\n`);
}

function updateEnvFile(providerKey, apiKey) {
  const envPath = path.join(__dirname, '..', '.env');
  
  if (!fs.existsSync(envPath)) {
    console.log('❌ .env file not found. Please run setup script first.');
    return false;
  }
  
  let envContent = fs.readFileSync(envPath, 'utf8');
  
  // Update AI_PROVIDER
  envContent = envContent.replace(
    /AI_PROVIDER=.*/,
    `AI_PROVIDER=${providerKey}`
  );
  
  // Update API key if provided
  if (apiKey) {
    const provider = providersConfig.providers[providerKey];
    const envVar = provider.setup.environment_var;
    
    const keyRegex = new RegExp(`${envVar}=.*`);
    if (envContent.match(keyRegex)) {
      envContent = envContent.replace(keyRegex, `${envVar}=${apiKey}`);
    } else {
      envContent += `\n${envVar}=${apiKey}\n`;
    }
  }
  
  fs.writeFileSync(envPath, envContent);
  console.log('✅ .env file updated successfully!');
  return true;
}

async function main() {
  console.log('🚀 GTM Automation - AI Provider Setup\n');
  console.log('This tool helps you choose and configure an AI provider for your GTM automation system.\n');
  
  displayRecommendations();
  displayProviders();
  
  const providerKeys = Object.keys(providersConfig.providers);
  const answer = await question(`Choose a provider (1-${providerKeys.length}) or 'q' to quit: `);
  
  if (answer.toLowerCase() === 'q') {
    console.log('👋 Goodbye!');
    rl.close();
    return;
  }
  
  const index = parseInt(answer) - 1;
  if (index < 0 || index >= providerKeys.length) {
    console.log('❌ Invalid selection. Please try again.');
    rl.close();
    return;
  }
  
  const selectedProvider = providerKeys[index];
  displaySetupInstructions(selectedProvider);
  
  const setupNow = await question('Would you like to update your .env file now? (y/n): ');
  
  if (setupNow.toLowerCase() === 'y' || setupNow.toLowerCase() === 'yes') {
    if (providersConfig.providers[selectedProvider].type !== 'local') {
      const apiKey = await question('Enter your API key (or press Enter to skip): ');
      updateEnvFile(selectedProvider, apiKey || null);
    } else {
      updateEnvFile(selectedProvider, null);
    }
  }
  
  console.log('\n🎉 Setup complete! Your GTM automation system is now configured to use ' + 
              providersConfig.providers[selectedProvider].name);
  console.log('\nNext steps:');
  console.log('1. Start your system: npm run start');
  console.log('2. Import workflows to n8n');
  console.log('3. Begin monitoring Reddit for GTM opportunities!');
  
  rl.close();
}

if (require.main === module) {
  main().catch(console.error);
}

module.exports = { updateEnvFile, displaySetupInstructions };