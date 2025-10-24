# WhatsApp Resume Processing with n8n

This project automates resume processing through WhatsApp using n8n, Twilio, Google APIs, and OpenAI.

## Features
- Receive resumes via WhatsApp (Twilio Sandbox)
- Extract text from PDF/DOCX files
- Parse candidate information (name, email, phone, skills, experience)
- Upload files to Google Drive
- Log data to Google Sheets
- Send auto-reply confirmation

## Prerequisites

### 1. Required Accounts & Credentials
- **Twilio Account** (free trial)
  - Account SID
  - Auth Token
  - WhatsApp Sandbox number
- **Google Cloud Project**
  - Google Drive API enabled
  - Google Sheets API enabled
  - Service Account JSON key
- **Gemini API Key** (for advanced text extraction)
- **ngrok** (for webhook exposure)

### 2. Setup Steps

#### A. Twilio Setup
1. Sign up at [Twilio](https://www.twilio.com)
2. Go to Messaging > Try it out > Try WhatsApp (Sandbox)
3. Note your sandbox number and join code
4. Configure webhook URL (after setting up ngrok)

#### B. Google Cloud Setup
1. Create project in [Google Cloud Console](https://console.cloud.google.com)
2. Enable Google Drive API and Google Sheets API
3. Create Service Account with Editor role
4. Download JSON key file as `service-account.json`
5. Create Google Sheet with columns:
   - Received_On, Sender, Name, Email, Phone, Skills, Experience, Resume_Link
6. Share sheet with service account email

#### C. Gemini API Setup
1. Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add to n8n credentials

## Quick Start (Demo-Ready)

1. **Clone and setup**:
   ```bash
   git clone <your-repo>
   cd whatsapp_auto
   ```

2. **Configure credentials**:
   ```bash
   # Copy environment template
   cp env.example .env
   
   # Edit .env with your credentials:
   # - NGROK_AUTHTOKEN (get from https://dashboard.ngrok.com)
   # - TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN
   # - GEMINI_API_KEY
   # - GOOGLE_SHEET_ID and GOOGLE_DRIVE_FOLDER_ID
   
   # Add Google service account JSON
   # Download from Google Cloud Console → Service Accounts
   # Place as: service-account.json
   ```

3. **Start everything with one command**:
   ```bash
   # Linux/Mac
   ./scripts/demo-setup.sh
   
   # Windows
   scripts\demo-setup.bat
   ```

4. **Configure Twilio webhook**:
   - Get your ngrok URL from http://localhost:4040
   - Set Twilio webhook to: `https://your-ngrok-url.ngrok.io/webhook/whatsapp`

5. **Import n8n workflow**:
   - Open http://localhost:5678 (admin/adminpass)
   - Import `n8n_workflow_export.json`
   - Configure credentials in n8n

6. **Test the system**:
   - Send WhatsApp message to your Twilio sandbox number
   - Watch the magic happen! ✨

## n8n Workflow Structure

```
Webhook (Twilio) 
    ↓
IF (has media?)
    ↓
HTTP Request (download file)
    ↓
Function (extract text)
    ↓
OpenAI (parse skills/experience)
    ↓
Google Drive (upload file)
    ↓
Google Sheets (append row)
    ↓
HTTP Request (send auto-reply)
```

## File Structure
```
whatsapp_auto/
├── docker-compose.yml
├── service-account.json
├── credentials/
├── n8n_data/
└── README.md
```

## Security Notes
- Change default n8n password before production
- Never commit credential files to version control
- Use environment variables for production
- Consider hosting n8n on cloud platform for production

## Troubleshooting
- Check n8n logs: `docker compose logs n8n`
- Verify ngrok is running and accessible
- Ensure all credentials are properly configured
- Check Google Sheet permissions
