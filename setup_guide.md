# Step-by-Step Setup Guide

## Phase 1: Account Setup (15-20 minutes)

### 1. Twilio WhatsApp Sandbox Setup
1. Go to [Twilio Console](https://console.twilio.com)
2. Sign up for free account
3. Navigate to **Messaging > Try it out > Try WhatsApp**
4. Follow instructions to join sandbox:
   - Send `join <sandbox-code>` to the provided number from your phone
   - Note your **Account SID** and **Auth Token** from console
   - Note the sandbox WhatsApp number (usually +14155238886)

### 2. Google Cloud Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create new project or select existing
3. Enable APIs:
   - Go to **APIs & Services > Library**
   - Search and enable: **Google Drive API**
   - Search and enable: **Google Sheets API**
4. Create Service Account:
   - Go to **IAM & Admin > Service Accounts**
   - Click **Create Service Account**
   - Name: `whatsapp-resume-processor`
   - Role: **Editor**
   - Click **Create Key** > **JSON** > Download
   - Save as `service-account.json` in project root
5. Create Google Sheet:
   - Create new Google Sheet
   - Add columns: `Received_On`, `Sender`, `Name`, `Email`, `Phone`, `Skills`, `Experience`, `Resume_Link`
   - Share with service account email (from JSON file)
   - Note the Sheet ID from URL

### 3. Gemini API Setup
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create account and get API key
3. Note the API key for n8n configuration

## Phase 2: Local Development Setup (10 minutes)

### 1. Install Prerequisites
```bash
# Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# Install ngrok
# Download from: https://ngrok.com/download
# Or via package manager:
# Windows: choco install ngrok
# Mac: brew install ngrok
# Linux: wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip
```

### 2. Project Setup
```bash
# Clone/navigate to project directory
cd whatsapp_auto

# Create required directories
mkdir -p n8n_data credentials

# Place your service-account.json in project root
# Copy service-account.json to project root
```

### 3. Start Services
```bash
# Start n8n
docker compose up -d

# In another terminal, start ngrok
ngrok http 5678
```

### 4. Configure Twilio Webhook
1. Copy the ngrok URL (e.g., `https://abc123.ngrok.io`)
2. In Twilio Console > Messaging > Try WhatsApp
3. Set **When a message comes in** to: `https://abc123.ngrok.io/webhook/whatsapp`

## Phase 3: n8n Workflow Setup (20-30 minutes)

### 1. Access n8n
- Open http://localhost:5678
- Login: `admin` / `adminpass`

### 2. Create Credentials
1. **Google Credentials**:
   - Go to Settings > Credentials
   - Add new credential > Google
   - Choose Service Account
   - Upload `service-account.json` content

2. **OpenAI Credentials**:
   - Add new credential > OpenAI
   - Enter your API key

3. **Twilio Credentials**:
   - Add new credential > HTTP Basic Auth
   - Username: Your Twilio Account SID
   - Password: Your Twilio Auth Token

### 3. Create Workflow
Follow the workflow structure in the main README.md

## Phase 4: Testing (5-10 minutes)

### 1. Test Webhook
1. Send a test message to your Twilio sandbox number
2. Check n8n execution logs
3. Verify data appears in Google Sheet
4. Check Google Drive for uploaded files

### 2. Troubleshooting
- Check n8n logs: `docker compose logs n8n`
- Verify ngrok is running: `curl https://your-ngrok-url.ngrok.io`
- Test Twilio webhook: Send message and check n8n executions

## Next Steps
- Customize auto-reply messages
- Add more sophisticated text extraction
- Set up production hosting
- Add error handling and logging
