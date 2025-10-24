# 🔐 n8n Credentials Setup Guide

## **Problem**: Private Key Validation Failed
The issue is that the private key in your JSON file has `\n` characters that need to be properly formatted.

## **Solution**: Use the Fixed JSON File

### **Step 1: Use the Correct JSON File**
- **Use**: `service-account-fixed.json` (I just created this for you)
- **Don't use**: `service-account.json.json` (has formatting issues)

### **Step 2: Set Up Google Credentials in n8n**

#### **Method 1: File Upload (Recommended)**
1. **Go to**: n8n → Settings → Credentials
2. **Click**: "Add Credential"
3. **Select**: "Google"
4. **Choose**: "Service Account"
5. **Upload**: `service-account-fixed.json` file
6. **Name**: `google-credentials`
7. **Save**

#### **Method 2: Manual Entry (If upload fails)**
1. **Credential Type**: "Google"
2. **Authentication**: "Service Account"
3. **Service Account Email**: `whatsapp-resume-processor@whatsappauto-476104.iam.gserviceaccount.com`
4. **Private Key**: Copy the entire private key from `service-account-fixed.json`
5. **Project ID**: `whatsappauto-476104`

### **Step 3: Share Your Google Sheet**
**IMPORTANT**: You must share your Google Sheet with the service account:

1. **Open your Google Sheet**
2. **Click "Share"** (top-right corner)
3. **Add email**: `whatsapp-resume-processor@whatsappauto-476104.iam.gserviceaccount.com`
4. **Permission**: "Editor"
5. **Click "Send"**

### **Step 4: Test the Connection**
1. **In n8n**: Go to your workflow
2. **Click on a Google Sheets node**
3. **Test the connection**
4. **Should work now!** ✅

## **Alternative: Use Environment Variables**

If the JSON file still doesn't work, you can set up Google credentials using environment variables:

### **Add to your .env file:**
```bash
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account-fixed.json
```

### **Or set in n8n Variables:**
1. **Go to**: Settings → Variables
2. **Add**: `GOOGLE_APPLICATION_CREDENTIALS`
3. **Value**: `/path/to/service-account-fixed.json`

## **Troubleshooting**

### **If you still get "Private key validation failed":**
1. **Check**: The private key has proper line breaks
2. **Verify**: No extra spaces or characters
3. **Try**: Copy the private key from `service-account-fixed.json`

### **If you get "Permission denied":**
1. **Check**: Google Sheet is shared with service account email
2. **Verify**: Service account has "Editor" permission
3. **Ensure**: Google Sheets API is enabled in Google Cloud Console

## **Quick Test**
After setting up credentials:
1. **Create a simple Google Sheets node**
2. **Test the connection**
3. **Should connect successfully!** 🎉

---

**Your service account is ready to use!** The fixed JSON file should resolve the private key validation error.
