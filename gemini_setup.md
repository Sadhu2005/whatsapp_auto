# Gemini API Setup Guide

## 🚀 **Why Gemini API is Perfect for This Project**

- **Cost-effective**: More affordable than OpenAI
- **Google Integration**: Seamless with Google Sheets/Drive
- **High Performance**: Fast response times
- **Multilingual**: Excellent for international resumes
- **Free Tier**: Generous free usage limits

## 📋 **Step-by-Step Gemini Setup**

### 1. **Get Your Gemini API Key**

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click **"Create API Key"**
4. Choose **"Create API key in new project"** (recommended)
5. Copy your API key (starts with `AIza...`)

### 2. **Configure n8n Credentials**

In n8n, create a new credential:

1. **Credential Type**: HTTP Header Auth
2. **Name**: `gemini-credentials`
3. **Header Name**: `X-Goog-Api-Key`
4. **Header Value**: `your_gemini_api_key_here`

### 3. **Update Environment Variables**

Add to your `.env` file:
```bash
GEMINI_API_KEY=your_gemini_api_key_here
```

### 4. **Test Gemini Integration**

You can test the Gemini API directly:

```bash
curl -H "Content-Type: application/json" \
     -H "X-Goog-Api-Key: YOUR_API_KEY" \
     -d '{
       "contents": [{
         "parts": [{
           "text": "Extract skills and experience from: John Smith, Software Engineer, 5 years experience in JavaScript, React, Node.js"
         }]
       }],
       "generationConfig": {
         "temperature": 0.3,
         "maxOutputTokens": 1000
       }
     }' \
     "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
```

## 🔧 **Gemini API Configuration in n8n**

### **HTTP Request Node Settings:**
- **URL**: `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent`
- **Method**: POST
- **Authentication**: HTTP Header Auth (gemini-credentials)
- **Headers**: 
  - `Content-Type: application/json`
- **Body** (JSON):
```json
{
  "contents": [{
    "parts": [{
      "text": "Extract the candidate's Skills and Experience from: {{ $json.raw_text }}"
    }]
  }],
  "generationConfig": {
    "temperature": 0.3,
    "maxOutputTokens": 1000
  }
}
```

## 💰 **Gemini Pricing (vs OpenAI)**

| Feature | Gemini 1.5 Flash | OpenAI GPT-3.5-turbo |
|---------|------------------|----------------------|
| **Input Cost** | $0.075 per 1M tokens | $0.50 per 1M tokens |
| **Output Cost** | $0.30 per 1M tokens | $1.50 per 1M tokens |
| **Free Tier** | 15 requests/minute | 3 requests/minute |
| **Speed** | Very Fast | Fast |

**Cost Savings**: ~85% cheaper than OpenAI!

## 🎯 **Gemini-Specific Features**

### **Enhanced Resume Parsing:**
- **Multilingual Support**: Handles resumes in multiple languages
- **Context Understanding**: Better at understanding resume structure
- **Skill Extraction**: More accurate technical skill identification
- **Experience Parsing**: Better at extracting years and job descriptions

### **Sample Prompt for Resume Extraction:**
```
Extract the following information from the resume text:
1. Full Name
2. Email Address
3. Phone Number
4. Skills (technical and soft skills)
5. Years of Experience
6. Current/Previous Job Title
7. Education Level

Return the information in JSON format with keys: name, email, phone, skills, experience_years, job_title, education

Resume text: {{ $json.raw_text }}
```

## 🔒 **Security Best Practices**

1. **Never commit API keys** to version control
2. **Use environment variables** for all credentials
3. **Rotate API keys** regularly
4. **Monitor usage** in Google AI Studio dashboard
5. **Set usage limits** to prevent unexpected charges

## 🚨 **Troubleshooting**

### **Common Issues:**

1. **"API key not valid"**
   - Check if API key is correctly set in n8n credentials
   - Verify the key is active in Google AI Studio

2. **"Rate limit exceeded"**
   - Gemini has rate limits (15 requests/minute on free tier)
   - Consider upgrading to paid tier for higher limits

3. **"Model not found"**
   - Ensure you're using the correct model name: `gemini-1.5-flash`
   - Check if the model is available in your region

4. **"Invalid request format"**
   - Verify JSON structure in the HTTP request body
   - Check that all required fields are included

## 📊 **Performance Expectations**

- **Response Time**: 1-3 seconds per request
- **Accuracy**: 90%+ for basic fields, 85%+ for skills/experience
- **Token Usage**: ~200-500 tokens per resume
- **Cost per Resume**: ~$0.0001 (extremely cost-effective)

## 🎬 **Demo Benefits with Gemini**

1. **Faster Processing**: Gemini is typically faster than OpenAI
2. **Better Integration**: Native Google services integration
3. **Cost Efficiency**: 85% cheaper than OpenAI
4. **Multilingual**: Can handle resumes in different languages
5. **Reliability**: Google's infrastructure ensures high uptime

---

**Ready to use Gemini API!** 🚀

Your system is now configured to use Google's powerful Gemini API for intelligent resume processing at a fraction of the cost of other AI services.
