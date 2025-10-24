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

![Twilio WhatsApp Sandbox Setup](🔄%20WhatsApp%20Resume%20Processing%20-%20n8n%20-%20Google%20Chrome%2024-10-2025%2017_31_07.png)

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

The complete workflow is visualized in the n8n editor with the following nodes:

### **Workflow Overview:**
```
Webhook (Twilio) 
    ↓
IF (has media?)
    ↓
HTTP Request (download file)
    ↓
Function (extract text)
    ↓
Gemini Analysis (parse skills/experience)
    ↓
Google Drive (upload file)
    ↓
Google Sheets (append row)
    ↓
HTTP Request (send auto-reply)
```

### **Visual Workflow:**
The n8n workflow editor shows a complete automation pipeline from receiving a WhatsApp message to sending an auto-reply:

![n8n Workflow](🔄%20WhatsApp%20Resume%20Processing%20-%20n8n%20-%20Google%20Chrome%2024-10-2025%2017_30_38.png)

The workflow includes:

1. **WhatsApp Webhook** - Entry point listening for Twilio webhooks
2. **Has Media?** - Conditional check for file attachments
3. **Download Resume** - Downloads PDF/DOCX files from Twilio
4. **Extract Basic Info** - JavaScript function for initial text parsing
5. **Gemini Analysis** - AI-powered extraction using Google Gemini API
6. **Upload to Drive** - Stores files in Google Drive
7. **Log to Sheets** - Records structured data in Google Sheets
8. **Send Auto-Reply** - Sends confirmation via Twilio WhatsApp API

## Expected Results

### **Google Sheets Output**
When a resume is processed, the system logs structured data into your Google Sheet:

| Column | Description | Example Data |
|--------|-------------|--------------|
| **Received_On** | Timestamp of message | `2025-10-24T10:45:30.000` |
| **Sender** | WhatsApp number | `whatsapp:70221` |
| **Name** | Extracted candidate name | `SADHU J` |
| **Email** | Extracted email address | `sadhuj2005@gmail.com` |
| **Phone** | Extracted phone number | `702215473` |
| **Skills** | AI-identified skills | `Languages: Python, Machine Learning, AI` |
| **Experience** | Work experience summary | `AI & ML Engineer with 3 years experience` |
| **Resume_Link** | Google Drive file link | `https://drive.google.com/file/d/abc123` |

### **Sample Google Sheet Output:**
The system creates a structured spreadsheet with:

![Google Sheets Output](🔄%20WhatsApp%20Resume%20Processing%20-%20n8n%20-%20Google%20Chrome%2024-10-2025%2017_30_58.png)

- **Header Row**: Column names (Received_On, Sender, Name, Email, Phone, Skills, Experience, Resume_Link)
- **Data Rows**: One row per processed resume with extracted information
- **Real-time Updates**: New entries appear automatically as resumes are processed

### **Google Drive Integration:**
- **File Upload**: Original resume files (PDF/DOCX) uploaded to designated folder
- **File Organization**: Files properly named and stored
- **Direct Links**: Shareable links available in Google Sheets

### **WhatsApp Auto-Reply:**
Users receive immediate confirmation messages like:
```
"Thank you SADHU J! Your resume has been received and logged successfully. We'll review it and get back to you soon."
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

### **Common Issues:**

#### **Private Key Validation Failed**
If you get `Private key validation failed: secretOrPrivateKey must be an asymmetric key when using RS256`:

1. **Fix the JSON file**: Open your `service-account.json` in a text editor
2. **Replace `\n` with actual newlines**: Find the `private_key` field and replace all `\n` with actual newline characters
3. **Re-upload to n8n**: Save the fixed file and re-upload when creating Google credentials

#### **General Troubleshooting:**
- **Check n8n logs**: `docker compose logs n8n`
- **Verify ngrok**: Check http://localhost:4040 for tunnel status
- **Test credentials**: Ensure all API keys are valid and properly configured
- **Google permissions**: Verify Google Sheet is shared with service account email
- **Twilio webhook**: Confirm webhook URL is correctly set in Twilio console

#### **Demo Setup Issues:**
- **Docker not running**: Start Docker Desktop before running setup scripts
- **ngrok not installed**: Use the Docker-based ngrok (no manual installation needed)
- **Port conflicts**: Ensure ports 5678 and 4040 are available
- **File permissions**: Make sure scripts are executable (Linux/Mac)

### **Getting Help:**
- Check the detailed setup guides in the repository
- Review the demo script for step-by-step instructions
- Ensure all prerequisites are met before starting
